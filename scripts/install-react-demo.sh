curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
yum update -y
yum install nodejs git firewalld -y


git clone https://github.com/rasmusson/react-oidc-pkce-demo.git
cd react-oidc-pkce-demo
npm install
