#cloud-config
users:
  - name: ${user}
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
write_files:
  - content: |
    <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="utf-8">
          <title>title</title>
        </head>
        <body>
          <h1>Hello, DevOps!</h1>
          <p>Instannce Name: __INSTANCE_NAME__</p>
          <img src="https://storage.yandexcloud.net/voitenko-25-08-2024/Razrabotka.webp" alt="DevOps" />
        </body>
      </html>

  path: /var/www/html/index.html
  owner: root:root
  permissions: '0644'

runcmd:
  - hostname=$(hostname) && sed -i "s/__INSTANCE_NAME__/$hostname/g" /var/www/html/index.html
    
  