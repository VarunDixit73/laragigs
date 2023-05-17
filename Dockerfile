FROM php:8.0.5

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update -y && apt-get install -y openssl zip unzip git

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN docker-php-ext-install pdo mbstring

# Copy project files
COPY . /var/www/html

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage

# Install project dependencies
RUN composer install --no-dev --optimize-autoloader

# Generate key
RUN php artisan key:generate

# Expose port
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]