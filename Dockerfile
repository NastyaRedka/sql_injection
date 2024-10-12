# Use the official PHP image with Apache
FROM php:8.0-apache

# Update system packages and install necessary dependencies
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    sqlite3 \
    && docker-php-ext-install pdo pdo_sqlite

# Enable PHP to parse .html files
RUN echo "AddType application/x-httpd-php .html" >> /etc/apache2/apache2.conf

# Copy the current directory (where the Dockerfile is located) to /var/www/html in the container
COPY . /var/www/html

# Set the working directory
WORKDIR /var/www/html

# Set file permissions
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80

# Start the Apache server
CMD ["apache2-foreground"]