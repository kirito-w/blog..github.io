local ubus      = require('ubus')
local cjson     = require('cjson.safe')
local log = require("lib.libsyslog")
local utils = require("lib.libutils")
local lfs = require("lfs")
local execute = utils._execute
local M = {}

local FILE_TYPE = {
    LOCAL_FILE = 1,
    REMOTE_FILE = 2,
}

local function check_file(firmware_path)
    if not firmware_path then
        log.error("not firmware_path")
        return nil
    end
    local cmd,res
    local rom_dir = "/tmp/Upgrade"
    execute(string.format("rm -rf %s; mkdir %s ;tar -zxvf %s -C %s",rom_dir,rom_dir,firmware_path,rom_dir))

    -- 判断是否存在version 文件
    cmd = string.format("find %s -name *.version", rom_dir)
    res = execute(cmd)
    local ver_file = res and res:gsub("\n",""):gsub("([%(%)])", "\\%1")
    if not (ver_file and #ver_file > 0) then
        log.error("not version file")
        return nil
    end

    -- 判断version 文件有是否存在至少两行信息
    cmd = string.format("wc -l < %s", ver_file)
    res = execute(cmd) or ""
    local line = res:gsub("\n","")
    if not (line and tonumber(line) >= 2) then
        log.error("version file has no enough line")
        return nil
    end

    -- 获取升级文件名字
    cmd = string.format("sed -n '1,1p' %s", ver_file)
    res = execute(cmd)
    local upgrade_file = res and res:gsub("\n",""):gsub("([%(%)])", "\\%1")
    if not (upgrade_file and #upgrade_file >= 0) then
        log.error("not upgrade file")
        return nil
    end

    -- 获取升级文件的MD5
    cmd = string.format("sed -n '2,1p' %s", ver_file)
    res = execute(cmd) or ""
    local upgrade_md5 = res:gsub("\n","")
    if not (upgrade_md5 and #upgrade_md5 == 32) then
        log.error("not upgrade md5")
        return nil
    end

    -- 获取升级文件的mode
    local upgrade_mode = upgrade_file:match('(.-)%..-v') or upgrade_file:match('(.-)%..-V')
    if not (upgrade_mode and #upgrade_mode > 0) then
        log.error("not upgrade mode")
        return nil, "INVALID_VERSION_FILE"
    end
    if upgrade_mode:find("\\%(") then
            upgrade_mode = upgrade_mode:match('(.-)\\%(')
    elseif upgrade_mode:find("%(") then
            upgrade_mode = upgrade_mode:match('(.-)%(')
    end

    -- 判断升级文件是否存在
    cmd = string.format("[ -e %s/%s ] && echo 'exist'", rom_dir, upgrade_file)
    res = execute(cmd)
    if not (res and res:match("exist")) then
        log.error("not upgrade file")
        return nil
    end

    -- 校验md5
    cmd = string.format("md5sum %s/%s | awk '{print $1}'", rom_dir, upgrade_file)
    res = execute(cmd) or ""
    local md5 = res:gsub("\n","")
    if not (md5 and #md5 == 32) then
        log.error("not upgrade md5")
        return nil
    end

    --比对md5
    if md5 ~= upgrade_md5 then
        log.error("md5 not equal, md5: %s, upgrade_md5: %s", md5, upgrade_md5)
        return nil
    end

    --校验型号
    local new_version = upgrade_mode:gsub('[%-_]', '')
    new_version = new_version and new_version:gsub(" ","") or ""
    local ver_str = execute("cat /etc/openwrt_release")
    local version = ver_str and ver_str:match("DISTRIB_ID='(.-)'"):gsub("%s", "") or ""
    version = version and version:gsub('[%-_]', '') or ""
    if version ~= new_version then
        log.error("version not equal, version: %s, new_version: %s", version, new_version)
        return nil
    end
    local path = "/tmp/Upgrade/" .. upgrade_file
    return path
end

---系统重启
M.system_reboot = function()
    execute("killall iot-agent_sonet")
    execute('reboot &')
    return true
end

---系统重置
M.system_reset = function()
    execute('sleep 3 && system_reset.sh -f &')
    return true
end

---系统升级
--- param.keep integer 0不保留配置升级 1保留配置升级
--- param.filepath string 文件路径
--- param.md5 string 文件md5
--- check_brand integer 0不检查固件包 1检查固件包
M.system_upgrade = function(param)
    if not (param and param.keep and param.filepath and param.md5 and param.check_brand) then
        return "system_upgrade: INVALID_PARAMS"
    end
    local md5 = execute(string.format([[md5sum %s | awk '{printf $1}']], param.filepath))
    if not (md5 and md5 == param.md5) then
        return "system_upgrade: INVALID_FILE_MD5"
    end
    -- 校验固件
    local path = param.filepath
    if tonumber(param.check_brand) == 1 then
        path = check_file(param.filepath)
        if not path then
            return "system_upgrade: INVALID_PARAMS"
        end
    end

    -- 升级前 drop_caches
    local sys =  string.format("sync;echo 3 > /proc/sys/vm/drop_caches; system_upgrade_ready -f %s; wifi down", path)
    execute(sys)

    local cmd = string.format([[sleep 10; nohup sysupgrade %s >/tmp/sysupgrade.txt 2>&1 & ]], path)
    if param.keep == 0 then
        cmd = string.format([[sleep 10; nohup sysupgrade -n %s >/tmp/sysupgrade.txt 2>&1 & ]], path)
    end
    execute(cmd)
    return true
end

---FOTA自校验系统升级
--- param.file_type integer 1本地路径升级 2远程下载升级
--- param.size integer 文件大小
--- param.md5 string 文件md5
--- param.url string 文件路径（URL）
M.system_fota_upgrade = function(param)
    if not (param and param.file_type and param.size and param.md5 and param.url) then
        return nil, "system_fota_upgrade: INVALID_PARAMS"
    end
    -- 升级前 drop_caches
    execute("sync;echo 3 > /proc/sys/vm/drop_caches")
    local conn = ubus.connect()
    local url = param.url

    local res = conn:call('fota', 'upgrade', {
        url = url,
        file_type = param.file_type,
        md5 = param.md5,
        size = param.size,
    })
    conn:close()
    if not res then
        return nil, "system_fota_upgrade: UBUS_CALL_FIALED"
    end

    return res
end

local function download_file(url)
    local file_path 
    local filename = "diff_patch.tar.gz"
    local download_dir = "/tmp/diff_upgrade/"

    local cmd = string.format("mkdir -p %s && rm -rf %s%s", download_dir, download_dir, filename)
    local r = execute(cmd)
    if not r then
        log.error("dir prepare failed")
        return nil
    end

    -- 下载前 drop_caches
    cmd = string.format([[sync;echo 3 > /proc/sys/vm/drop_caches; wget -q -T 10 -O %s%s %s]], download_dir, filename, url)
    r = execute(cmd)
    if not r then
        log.error("file download failed")
        return nil
    end

    return file_path
end

-- 差分升级包校验
local function diff_patch_check(file_path, upgrade_md5)
    -- 判断升级文件是否存在
    local cmd = string.format("[ -e %s ] && echo 'exist'", file_path)
    local res = execute(cmd)
    if not (res and res:match("exist")) then
        log.error("not upgrade file")
        return nil
    end

    -- 校验md5
    cmd = string.format("md5sum %s | awk '{print $1}'", file_path)
    res = execute(cmd) or ""
    local md5 = res:gsub("\n","")
    if not (md5 and #md5 == 32) then
        log.error("not upgrade md5")
        return nil
    end

    --比对md5
    if md5 ~= upgrade_md5 then
        log.error("md5 not equal, md5: %s, upgrade_md5: %s", md5, upgrade_md5)
        return nil
    end

    --检测overlay剩余空间
    cmd = string.format("df -h | grep overlayfs | awk '{print $4}' | sed 's/M//' | xargs echo -n")
    res = execute(cmd)
    if not res then
        log.error("execute cmd: %s failed", cmd)
        return nil
    end
    if tonumber(res) <= 1 then
        log.error("overlay space is insufficient : %s", res)
        return nil
    end

    return true
end

local function diff_patch_apply(tar_path)
    local diff_patches_path = "/tmp/diff_patches"

    local cmd = string.format("mkdir %s; tar -zxvf %s -C %s", diff_patches_path, tar_path, diff_patches_path)
    local res = execute(cmd)
    if not res then
        return nil, "system_diff_upgrade: DECOMPRESSION FAILED"
    end

    for file in lfs.dir(diff_patches_path) do
        if file ~= "." and file ~= ".." then
            cmd = string.format("cp -r %s /%s", file, file)
            res = execute(cmd)
            if not res then
                return nil, "system_diff_upgrade: COPY FAILED"
            end
        end
    end
    
    return true
end 

---差分升级
--- param.file_type integer 1本地路径升级 2远程下载升级
--- param.md5 string 文件md5
--- param.url string 文件路径（URL）
M.system_diff_upgrade = function(param)
    if not (param and param.file_type and param.md5 and param.url) then
        return nil, "system_diff_upgrade: INVALID_PARAMS"
    end

    local file_path = param.url

    if param.file_type == FILE_TYPE.REMOTE_FILE then
        file_path = download_file(param.url)
        if not file_path then
            return nil, "system_diff_upgrade: DOWNLOAD_FILE_FAILED"
        end
    end

    -- 校验固件
    file_path = diff_patch_check(file_path, param.md5)
    if not file_path then
        return nil, "system_diff_upgrade: INVALID_PARAMS"
    end

    -- 差分升级
    local r, e = diff_patch_apply(file_path)
    if not r then
        return nil, e
    end

    return true
end

---自校验系统升级状态
M.system_get_fota_upgrade_status = function(param)
    local conn = ubus.connect()
    local res = conn:call('fota', 'upgrade_status', {})
    local wait = false
    conn:close()
    if not res then
        return false, "system_get_compatible_upgrade_status: UBUS_CALL_FIALED"
    end

    local STATUS_MAP = {
        [0] = "UPGRADED",               -- 最新或则没有升级任务
        [1] = "UPGRADE_BEGIN",          -- 升级开始
        [2] = "REQUEST_INVALID",        -- 非法请求
        [3] = "DOWNLOAD_BEGIN",         -- 开始下载
        [4] = "DOWNLOADING",            -- 下载中
        [5] = "DOWNLOAD_END",           -- 下载结束
        [6] = "DOWNLOAD_SUCCESS",       -- 下载成功
        [7] = "DOWNLOAD_FAILED",        -- 下载失败
        [8] = "VERIFYING",              -- 校验中
        [9] = "UNVERIFIED",             -- 校验失败
        [10] = "VERIFIED",               -- 校验成功
        [11] = "UPGRADE_FILE_NOT_FOUND", -- 升级固件不存在
        [12] = "UPGRADE_REBOOT",         -- 升级成功，等待重启
        [13] = "UPGRADE_SUCCESSED" 	    -- 升级成功
    }

    local WAIT_MAP = {
        [3] = "DOWNLOAD_BEGIN",         -- 开始下载
        [4] = "DOWNLOADING",            -- 下载中
        [8] = "VERIFYING",              -- 校验中
        [10] = "VERIFIED",               -- 校验成功
    }

    if WAIT_MAP[res.data.status] then
        log.info("check fota status: %s, keep wait", STATUS_MAP[res.data.status])
        wait = true
    end
    log.info("check fota status: %s, return", STATUS_MAP[res.data.status])
    res.data.status = STATUS_MAP[res.data.status]
    return wait, res
end

return M
