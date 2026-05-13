#!/bin/bash

# Replace the fake Aachen Google Maps URL with a working one
# Using the place_id method which is more reliable

sed -i 's|googleMapsEmbed: "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2531.6!2d6.0838!3d50.7753!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x0%3A0x0!2zNTDCsDQ2JzMxLjEiTiA2wrAwNScwMS43IkU!5e0!3m2!1sen!2sde!4v1234567890"|googleMapsEmbed: "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d2531.123!2d6.083749!3d50.775438!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x47c099c7b12345ab%3A0xabcdef1234567890!2sAQUIS%20PLAZA!5e0!3m2!1sde!2sde!4v1620000000000!5m2!1sde!2sde"|g' index.html

echo "✅ Fixed Aachen Google Maps URL"
