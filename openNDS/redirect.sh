#!/bin/sh
# Simple HTML redirection page with immediate JavaScript-based redirect

# Variables
title="Redirecting Page"
redirect_url="http://hub.test.feifan.art/web/index?macAddress=123&deviceId=123&channelId=123"  # Replace with your target URL 

# Functions
generate_redirect_page() {
    header
    redirect_body
    footer
}

header() {
    # HTML Header
    echo "<!DOCTYPE html>
<html>
<head>
    <meta http-equiv=\"Cache-Control\" content=\"no-cache, no-store, must-revalidate\">
    <meta http-equiv=\"Pragma\" content=\"no-cache\">
    <meta http-equiv=\"Expires\" content=\"0\">
    <meta charset=\"utf-8\">
    <title>$title</title>
    <script>
        // Immediate redirection
        window.location.href = \"$redirect_url\";
    </script>
</head>
<body>"
}

redirect_body() {
    # HTML Body
    echo "
    <div style=\"text-align:center; margin-top:20%;\">
        <h1>Redirecting...</h1>
        <p>You are being redirected to <a href=\"$redirect_url\">$redirect_url</a>.</p>
        <p>If the page does not redirect automatically, click <a href=\"$redirect_url\">here</a>.</p>
    </div>"
}

footer() {
    # HTML Footer
    echo "
</body>
</html>"
}

# Main script
generate_redirect_page

