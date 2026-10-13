#!/bin/bash

# نمایش پیام شروع
echo "=== Starting Pasarguard Custom Template Setup ==="

# ۱. ساخت پوشه مقصد روی سرور کاربر
echo "--> Creating target directory..."
sudo mkdir -p /var/lib/pasarguard/templates/subscription

# ۲. دانلود مستقیم فایل index.html از گیت‌هاب شما
echo "--> Downloading subscription index.html..."
sudo curl -sSL -o /var/lib/pasarguard/templates/subscription/index.html "https://raw.githubusercontent.com/hta9158/Viosub/main/templates/subscription/index.html"

# ۳. بررسی و فعال‌سازی متغیرها در فایل env پاسارگارد
# (توجه: pasarguard فایل env خود را معمولاً در مسیر زیر یا از طریق دستور خود مدیریت می‌کند)
ENV_FILE="/var/lib/pasarguard/.env"

if [ -f "$ENV_FILE" ]; then
    echo "--> Updating environment file..."
    
    # فعال کردن یا اضافه کردن CUSTOM_TEMPLATES_DIRECTORY
    if grep -q "CUSTOM_TEMPLATES_DIRECTORY" "$ENV_FILE"; then
        sudo sed -i 's|^#\?\s*CUSTOM_TEMPLATES_DIRECTORY=.*|CUSTOM_TEMPLATES_DIRECTORY="/var/lib/pasarguard/templates/"|' "$ENV_FILE"
    else
        echo 'CUSTOM_TEMPLATES_DIRECTORY="/var/lib/pasarguard/templates/"' | sudo tee -a "$ENV_FILE" > /dev/null
    fi

    # فعال کردن یا اضافه کردن SUBSCRIPTION_PAGE_TEMPLATE
    if grep -q "SUBSCRIPTION_PAGE_TEMPLATE" "$ENV_FILE"; then
        sudo sed -i 's|^#\?\s*SUBSCRIPTION_PAGE_TEMPLATE=.*|SUBSCRIPTION_PAGE_TEMPLATE="subscription/index.html"|' "$ENV_FILE"
    else
        echo 'SUBSCRIPTION_PAGE_TEMPLATE="subscription/index.html"' | sudo tee -a "$ENV_FILE" > /dev/null
    fi

    echo "--> Pasarguard environment updated successfully!"
else
    echo "--> Warning: Pasarguard .env file not found at $ENV_FILE."
    echo "--> Please run 'pasarguard edit-env' and manually uncomment/set these lines:"
    echo '    CUSTOM_TEMPLATES_DIRECTORY="/var/lib/pasarguard/templates/"'
    echo '    SUBSCRIPTION_PAGE_TEMPLATE="subscription/index.html"'
fi

echo "=== Setup Completed Successfully! ==="