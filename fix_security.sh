#!/bin/bash

# Fix all external links without rel="noopener noreferrer"
# Calendly links
sed -i 's/target="_blank" class="header-cta"/target="_blank" rel="noopener noreferrer" class="header-cta"/g' index.html
sed -i 's/target="_blank" class="doctor-cta"/target="_blank" rel="noopener noreferrer" class="doctor-cta"/g' index.html
sed -i 's/target="_blank" class="btn-secondary"/target="_blank" rel="noopener noreferrer" class="btn-secondary"/g' index.html
sed -i 's/target="_blank" title="Kontakt">Kontakt/target="_blank" rel="noopener noreferrer" title="Kontakt">Kontakt/g' index.html

# Social media links - also add complete URLs
sed -i 's|href="https://instagram.com"|href="https://instagram.com/myhealthandbeauty.app"|g' index.html
sed -i 's|href="https://facebook.com"|href="https://facebook.com/myhealthbeautylounge"|g' index.html
sed -i 's|href="https://tiktok.com"|href="https://tiktok.com/@myhealthandbeauty.com"|g' index.html

# Add rel to social media
sed -i 's/target="_blank" title="Instagram"/target="_blank" rel="noopener noreferrer" title="Instagram"/g' index.html
sed -i 's/target="_blank" title="Facebook"/target="_blank" rel="noopener noreferrer" title="Facebook"/g' index.html
sed -i 's/target="_blank" title="TikTok"/target="_blank" rel="noopener noreferrer" title="TikTok"/g' index.html

echo "✅ All external links secured with rel=noopener noreferrer"
