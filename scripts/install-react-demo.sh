curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
yum install nodejs git firewalld -y


git clone https://github.com/rasmusson/react-oidc-pkce-demo.git
cd react-oidc-pkce-demo
npm install

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --zone=public --add-port=3000/tcp --permanent
firewall-cmd --reload
