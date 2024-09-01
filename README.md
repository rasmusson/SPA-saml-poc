# Demo of a React SPA authenticating against a SAML IdP
This is a vagrant project for automatically setting up an demo environment for a SAML SPA integration.
The project was created as a part of [this blog post on the subject](https://blog.samlsecurity.com/post/saml-for-react-spa/?utm_source=github&utm_medium=link&utm_campaign=SPA-saml-poc&utm_id=SPA-saml-poc&utm_content=SPA-saml-poc). The blog post shows how to configure the environment manualy while this project does the same thing, but automaticaly.

The demo shows how to set up a React SPA to authenticate users against a SAML ADFS IdP. This is done by employing a brokeded authentication pattern using Keycloak.
A React SPA is not suitable for using SAML. Using brokered authentication, the the SPA will talk OIDC to Keycloak and keycloak will then translate to SAML against the IdP.

![brokered-auth](https://user-images.githubusercontent.com/393610/157530985-75b67508-434e-48ab-9c6c-eedb9d9af30a.png)

# Prerequisites
To start up the environment, install vagrant and the following plugins using

```
vagrant plugin install <plugin name>
```
* vagrant-host-shell
* vagrant-reload
* vagrant-hostmanager
* vagrant-timezone
* vagrant-vbguest

# Starting the environment
Start the environment by running.
```
vagrant up keycloak adfs react
```
The first time you run it, it will take a lot of time. Especially setting up ADFS.
