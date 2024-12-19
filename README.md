# SSL-Auto

SSL-Auto is a script designed to simplify the process of setting up free SSL certificates on NGINX servers. This script supports both single-domain and wildcard-domain setups using Let's Encrypt and automates renewal to ensure your SSL certificates remain valid.

## Features

- **Single Domain SSL Setup:** Quickly set up SSL for individual domains, including subdomains (e.g., `www.example.com`).
- **Wildcard Domain SSL Setup:** Obtain and configure SSL for all subdomains of a domain (e.g., `*.example.com`).
- **Automated Renewal:** Adds a cron job for automatic renewal of SSL certificates.
- **Interactive User Interface:** User-friendly, color-coded prompts and menus for easy navigation.

## Prerequisites

- **Root Access:** The script must be run as root or with `sudo`.
- **Supported OS:** Linux distributions like Ubuntu or Debian.
- **NGINX Installed:** Ensure that NGINX is installed and running on your server.
- **Certbot Installed:** The script will install Certbot if it is not already available.

## Installation

Clone the repository:

```bash
git clone https://github.com/Sincan2/Ssl-auto.git
cd Ssl-auto
```

Make the script executable:

```bash
chmod +x ssl_auto.sh
```

## Usage

Run the script:

```bash
./ssl_auto.sh
```

### Menu Options

1. **Single Domain Setup**
   - Enter your domain name (e.g., `example.com`).
   - The script will set up SSL for both the root domain and `www` subdomain.

2. **Wildcard Domain Setup**
   - Enter your domain name (e.g., `example.com`).
   - Ensure you have access to your domain's DNS settings to add the required TXT record.
   - Follow the instructions provided by the script to complete DNS verification.

3. **Exit**
   - Exit the script.

## Example Walkthrough

### Single Domain
1. Choose the "Single Domain" option from the menu.
2. Enter `example.com` as the domain name.
3. The script configures SSL for `example.com` and `www.example.com`.

### Wildcard Domain
1. Choose the "Wildcard Domain" option from the menu.
2. Enter `example.com` as the domain name.
3. The script generates DNS TXT record instructions. Add this record in your domain's DNS settings.
4. Wait for the countdown and complete DNS verification.
5. SSL is configured for `*.example.com` and `example.com`.

## Cron Job for Renewal

The script automatically sets up a cron job to renew SSL certificates daily:

```bash
0 0 * * * certbot renew --quiet
```

This ensures your certificates are always up to date.

## Troubleshooting

- Ensure your domain's DNS settings are correctly configured.
- If DNS verification fails, double-check the TXT records for wildcard domains.
- For manual installation of Certbot, visit [Certbot's official site](https://certbot.eff.org/).

## Contributing

Contributions are welcome! Feel free to fork the repository and submit a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

