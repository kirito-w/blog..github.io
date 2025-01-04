#!/bin/bash

# 生成签名的函数
generate_signature() {
    local data="$1"
    local secret="$2"
    
    # 使用 echo 将数据转为字节流，并通过 openssl 计算 HMAC-SHA256
    echo -n "$data" | openssl dgst -sha256 -hmac "$secret" -binary | base64
}


# 获取当前时间戳（秒）
timestamp=$(date +%s)

# 获取当前毫秒部分（通过生成一个随机数来模拟）
milliseconds=$(printf "%03d" $((RANDOM % 1000)))

# 拼接秒和毫秒部分
full_timestamp="${timestamp}${milliseconds}"

# 示例：调用 generate_signature 函数
data="apiKey=5a86241a275046cabbb42cd82c7231de&timestamp=${full_timestamp}&channelId=202412279806216065&deviceId=123&macAddress=456"
secret="AfuH9nn7cNvWgTB4+ZvLyvE4WQJ5ASvuQRE7yaeiPCY="
signature=$(generate_signature "$data" "$secret")

# 输出签名结果
echo "Generated Signature: $signature"

echo "----------------------------------------"

url="http://vortexapi.test.feifan.art/device/wifi/auth/status?channelId=202412279806216065&deviceId=123&macAddress=456"
timestamp="${full_timestamp}"  # 假设 full_timestamp 是一个环境变量
apiKey="5a86241a275046cabbb42cd82c7231de"
signature="$signature"  # 假设 signature 也是一个环境变量

# 发送请求并获取 JSON 响应
response=$(curl --silent --location "$url" \
  --header "timestamp: ${full_timestamp}" \
  --header "apiKey: ${apiKey}" \
  --header "signature: ${signature}")

# 使用 jq 解析 JSON 数据
code=$(echo "$response" | jq -r '.code')
status=$(echo "$response" | jq -r '.data.status')
onlineDuration=$(echo "$response" | jq -r '.data.onlineDuration')
onlineTime=$(echo "$response" | jq -r '.data.onlineTime')
pollingIntervalTime=$(echo "$response" | jq -r '.data.pollingIntervalTime')
message=$(echo "$response" | jq -r '.message')
timestamp=$(echo "$response" | jq -r '.timestamp')

echo "----------------------------------------"

# 打印解析结果
echo "Code: $code"
echo "Status: $status"
echo "Online Duration: $onlineDuration"
echo "Online Time: $onlineTime"
echo "Polling Interval Time: $pollingIntervalTime"
echo "Message: $message"
echo "Timestamp: $timestamp"
