## Day 17: Apache2 Deep Dive & Full WordPress Deployment (Mar 29, 2026)

### 🌐 1. Apache2 Web Server Architecture
We didn't just install Apache; we dissected its entire directory structure in `/etc/apache2/`.

**Core Configuration Files & Directories:**
- `apache2.conf`: The main configuration file for the server.
- `envvars`: Holds environment variables for Apache.
- `security.conf`: Manages server signatures and security headers.
- `000-default.conf` / `default-ssl.conf`: Default virtual host files for HTTP (80) and HTTPS (443).

**The "Available vs. Enabled" Architecture:**
Apache uses a brilliant symlink system to enable/disable features without deleting configuration files.
- `sites-available/` vs `sites-enabled/`: Stores Virtual Host files (different websites on one server).
- `mods-available/` vs `mods-enabled/`: Stores Apache modules (like `rewrite` or `php`).
- `conf-available/` vs `conf-enabled/`: Stores global configurations.
*To enable a site:* `sudo a2ensite mywebsite.conf`
*To disable a site:* `sudo a2dissite mywebsite.conf` (Followed by `systemctl reload apache2`).

**Server Logs (Crucial for Troubleshooting):**
Located in `/var/log/apache2/`.
- `access.log`: Records every HTTP request (IP, Browser, Time).
- `error.log`: Records server errors, PHP crashes, and missing files (404s).

### 🗄️ 2. Database Configuration (MySQL/MariaDB)
WordPress requires a database to store content.
CREATE DATABASE wordpress;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;

### 3. Deploying WordPress
Followed the official Ubuntu documentation to set up the application layer.
#### A. Downloading and Structuring
i.Downloaded the latest tarball using curl.
ii.Extracted files to the standard directory: /srv/www/wordpress/.
iii.Set proper ownership: sudo chown -R www-data:www-data /srv/www/wordpress/.

#### B. Automating Configuration with sed:
Instead of manually editing wp-config.php with vim, we used sed (Stream Editor) to inject the database credentials directly from the command line!
```
sed -i 's/database_name_here/wordpress/' /srv/www/wordpress/wp-config.php
sed -i 's/username_here/wpuser/' /srv/www/wordpress/wp-config.php
sed -i 's/password_here/password/' /srv/www/wordpress/wp-config.php
```
#### C.  Configuring the Apache Virtual Host:
```
Created /etc/apache2/sites-available/wordpress.conf:

<VirtualHost *:80>
    DocumentRoot /srv/www/wordpress
    <Directory /srv/www/wordpress>
        Options FollowSymLinks
        AllowOverride Limit Options FileInfo
        DirectoryIndex index.php
        Require all granted
    </Directory>
</VirtualHost>
```
Enabled the site: sudo a2ensite wordpress.conf, disabled the default: sudo a2dissite 000-default.conf, and reloaded Apache.

### 4.  Final Testing & Publishing
i.Used curl -I http://localhost to verify the HTTP status code (200 OK).
ii.Browsed to the VM's bridged IP address in the Windows host browser.
iii.Completed the famous "5-minute WordPress installation" GUI.
iv.Successfully wrote and published my first blog post!