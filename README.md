# AD_Lab
The purpose of this repository is to document my progress towards mastering Active Directory and Windows Server. Hyper-V will be used as the hypervisor of choice during this process. I will be updating my progress below.

# Documentation
## Setting Up Windows Server VM Within Hyper-V
My first step in this homelab was to install Windows Server 2022 within Hyper-V.
<img width="1919" height="1028" alt="Screenshot 2025-12-21 183314" src="https://github.com/user-attachments/assets/12facdbf-d3ca-4f8a-be46-67f14d31611e" />

From Hyper-V, on the right hand side, we can create a new virtual machine by selecting "New" and then "Virtual Machine", which brings us into the "New Virtual Machine Wizard".
I wanted to provision this machine with around 8GB of memory, so I entered 8192 into the text box below, although if you're copying this you can put whatever you feel is best.
<img width="701" height="533" alt="Screenshot 2025-12-21 183612" src="https://github.com/user-attachments/assets/d0237d31-c237-4b4c-8e7f-76abc1897971" />

Then we get to the virtual hard disk step, I left this as it was besides the Size box, which I knocked down to 100GB, since this is a home lab and for my purposes I do not think I will be needing more than that.
<img width="699" height="531" alt="Screenshot 2025-12-21 184005" src="https://github.com/user-attachments/assets/00cd5234-3218-4ed0-8509-3bc56be428c1" />

Then on the next screen we can configure how we want the machine installed. This is Hyper-V, and we are using the Server Evaluation .iso, so we will select .iso and specify our location and then continue until we finish.
<img width="701" height="528" alt="Screenshot 2025-12-21 184017" src="https://github.com/user-attachments/assets/0da8744f-82c0-426f-af6f-13e904705c36" />

The next step that we have to do is configure our networking. My idea for this is to have the server connected to the internet, as well as have an extra adapter for an internal network where a virtual Windows 11 machine can connect.
We do this by creating an external adapter through the virtual switch manager, as well as an internal adapter and connecting both of them to our new virtual machine through it's network settings.
<img width="716" height="676" alt="Screenshot 2025-12-21 184106" src="https://github.com/user-attachments/assets/4d7e4bcf-6c4d-4a30-8112-2826741f4f0b" />
<img width="714" height="681" alt="Screenshot 2025-12-21 200507" src="https://github.com/user-attachments/assets/f8ba9535-3d52-45bf-ada6-c4009c7f9f75" />
<img width="708" height="678" alt="Screenshot 2025-12-21 200732" src="https://github.com/user-attachments/assets/1738b664-1ece-4f25-a87b-1a9fe397785d" />

Once this is done, we can start with the installation of Windows Server 2022. First we start and connect to our virtual machine...
<img width="1019" height="865" alt="Screenshot 2025-12-21 184638" src="https://github.com/user-attachments/assets/88f44940-7b41-4553-ad3c-f32b6346b709" />

We then go through the proper steps to install it, making sure to select the option with "Desktop Experience". This ensures we get the full GUI along with windows server.
<img width="1021" height="862" alt="Screenshot 2025-12-21 184707" src="https://github.com/user-attachments/assets/5c915c0e-011e-440e-84ff-3fef509d1a76" />

We then create a password for our lab, I like to make mine at least 12 characters utilizing uppercase, lowercase, numbers, and special characters.
<img width="1022" height="860" alt="Screenshot 2025-12-21 184955" src="https://github.com/user-attachments/assets/9f2be0dd-0cd5-450b-8b3f-bb6fcd00194d" />

## Configuring Networking
To configure our networking, we want to make sure that we set a static IP for our second ethernet adapter (internal network), leaving our first ethernet adapter (external network) untouched. This will allow the server to have an external internet connection while providing an internal connection for our virtual Windows 11 VM to attach to. We will set the static IP to 192.168.10.1 with a subnet of 255.255.255.0, leaving the gateway untouched, and setting our DNS as the same static IP 192.168.10.1.
<img width="1362" height="869" alt="Screenshot 2025-12-21 190549" src="https://github.com/user-attachments/assets/120468e7-4a59-48b3-a87f-1691f5657e5c" />

## Installing Active Directory DS
AD DS is the core Windows Server role for network identities, resources, and security. This will give us the power to enforce things like group policy and access control, as well as enable authentication. It is therefore essential that we install and configure it for our lab. This will provide a single point of administration and ensure users can log in and access resources within the lab environment. First we open the "Add Roles and Features Wizard".
<img width="1363" height="866" alt="Screenshot 2025-12-21 190741" src="https://github.com/user-attachments/assets/28a12c99-30d3-4ffb-adb9-84f67e2d0f32" />

We will hit next until we get to "Server Selection" and make sure our server is selected, which it should be by default.
<img width="1361" height="870" alt="Screenshot 2025-12-21 190802" src="https://github.com/user-attachments/assets/ea9a5a90-5fec-4925-a29e-06e17d60b850" />

We will then get to "Server Roles" and we will make sure that "Active Directory Domain Services" is selected.
<img width="1366" height="871" alt="Screenshot 2025-12-21 190820" src="https://github.com/user-attachments/assets/f0081448-a5e7-461d-b564-6979d31d707c" />

It will then install the feature, and ask us to set up our domain. This should appear within the text box after installation.
<img width="1360" height="874" alt="Screenshot 2025-12-21 190852" src="https://github.com/user-attachments/assets/60fe8839-a3f5-4132-b749-9932e7ed4814" />

When we go into that menu, we can select "Add a new forest" and specify a domain. For this I am choosing "Lab.local", feel free to get creative with this even though I am keeping it simple.
<img width="1367" height="873" alt="Screenshot 2025-12-21 191023" src="https://github.com/user-attachments/assets/181639ac-ce0b-4173-914f-df6c5191822c" />

We'll continue through and come to the "Additional Options", It will specify a NetBIOS domain name. Do not worry that this does not include the .local from the previous step.
<img width="1360" height="869" alt="Screenshot 2025-12-21 191539" src="https://github.com/user-attachments/assets/1efbfe5c-9f51-4153-92ec-35c76260b9ec" />

After a restart you should be greeted with the login screen. You will see underneath the credentials the name of your new forest and will be able to log into the administrator account with the same password you have created during setup.
<img width="1363" height="863" alt="Screenshot 2025-12-21 192100" src="https://github.com/user-attachments/assets/58cad782-547e-4f7a-b2d6-465ba3069231" />

## Changing Server Name
Its normally best practice to create a specific server name for your Windows Server that is useful. This can range from a variety of things but is usually defined by what the server is being used for. For our purposes we will name this one "LAB-DC-01", since we are using it for a "LAB", it is a "DC" or "Domain Controller", and it is number "01".
<img width="1363" height="875" alt="Screenshot 2025-12-21 192300" src="https://github.com/user-attachments/assets/0b7ad3c9-2201-452e-a0e6-daa7dac020e2" />

After a restart, we can verify our settings in the Local Server menu.
<img width="1367" height="874" alt="Screenshot 2025-12-21 192447" src="https://github.com/user-attachments/assets/5e74a922-13d3-4ec4-8847-69b6c114230f" />

## Enabling DHCP
In order for our server to hand out IP addresses to our internal network, we are going to have to enable DHCP. We can do this by first installing this as a role, just like when we installed AD DS, so go to "Add Roles and Features" and click on DHCP Server, continue until you get to this section.
<img width="1359" height="867" alt="Screenshot 2025-12-22 102852" src="https://github.com/user-attachments/assets/b9e3c9f1-5167-487b-b15c-6edc42bfdb33" />

The next section is pretty straightforward as well, just keep clicking on continue.
<img width="1357" height="867" alt="Screenshot 2025-12-22 102917" src="https://github.com/user-attachments/assets/768c0cf7-366f-4eb4-a604-3a87782f77a4" />

Now our Goal is to configure a scope. A scope is a range of IP addresses that will be either provisioned or reserved for devices connecting to our server. To do this we can open "Tools" and select "DHCP".
<img width="1358" height="870" alt="Screenshot 2025-12-22 103012" src="https://github.com/user-attachments/assets/d04087be-c4fc-4561-9cba-555cf985eff3" />

This will open the DHCP server manager. Now we select more actions, and then "New Scope".
<img width="758" height="563" alt="Screenshot 2025-12-22 103023" src="https://github.com/user-attachments/assets/e800c8a4-32d4-4bf6-ab2b-8aaa12e41cf3" />

The "New Scope Wizard" will pop up, we can then enter in an IP address range. Even though i have no plans to use 200 devices, I am going to create a range of 192.168.10.1 - 192.168.10.200 just for this lab's sake.
<img width="1350" height="697" alt="Screenshot 2025-12-22 104754" src="https://github.com/user-attachments/assets/a2f2d8aa-517d-49bc-957a-cae8426c880d" />

It will then ask us if we want to create exclusions. An exclusion is an IP range that will be reserved for any devices that we want to add in the future. I do plan on adding more management devices in the future, such as a second server, and will create an excluded address range of 192.168.10.1 - 192.168.10.30.
<img width="1025" height="634" alt="Screenshot 2025-12-22 104803" src="https://github.com/user-attachments/assets/6c425641-ab3e-4268-a7f8-c0d9f321bfa7" />

The next section we will be looking at is the router, and it will ask us the IP for the default gateway. Now, you can leave this blank if you do not want the computers connecting to your domain to have internet, but for learning purposes and because I do like to rabbit hole, I will be configuring NAT in the future. So I will set this to 192.168.10.1. (It should be noted, earlier in this lab I configured the IP of the server to this IP address, but changed the IP of the server to 192.168.10.10 later because of the network configuration I want to set up.)
<img width="1355" height="842" alt="Screenshot 2025-12-22 104840" src="https://github.com/user-attachments/assets/b9281389-1633-49ec-9d0a-fae3c8eec410" />

Now, we get to the domain name and DNS servers section. If DNS is enabled on your server, this should automatically populate. If it does not automatically populate, you can type in the server name(In my case the name of the forest, Lab.local) and it should pull the IP into the next box.
<img width="1352" height="837" alt="Screenshot 2025-12-22 105003" src="https://github.com/user-attachments/assets/c75d4e90-6cf8-4698-be03-bfbebb17e84d" />

Then we simply state that we want to activate this scope now.
<img width="1356" height="833" alt="Screenshot 2025-12-22 105026" src="https://github.com/user-attachments/assets/c36d822a-6969-4270-a595-7f4eb8958c5e" />

That should do it for DHCP configuration!

## Preventing Future DNS Issues
I wanted to go ahead and prevent any DNS issues in the future so I pulled up the DNS Server Manager.
<img width="1356" height="871" alt="Screenshot 2025-12-22 104121" src="https://github.com/user-attachments/assets/bec6960b-13c3-41d8-af03-3961a9671c26" />

I then went to interfaces, and selected the IP of the internal ethernet adapter's interface.
<img width="1359" height="863" alt="Screenshot 2025-12-22 104256" src="https://github.com/user-attachments/assets/db15b98c-ac35-453f-9cbb-a093c99dd30b" />

## Connecting Windows VM to Domain
Now its time to connect our first Windows 11 VM to the domain! This assumes you already have a Windows VM setup. It is as simple as going into Settings, searching for Access Work or School, selecting Connect and "Join this device to a local Active Directory domain", and then inputting the name of our domain, which is "Lab.local".
<img width="922" height="749" alt="Screenshot 2025-12-22 105518" src="https://github.com/user-attachments/assets/c537ecca-7c77-4358-87e3-846489d27e26" />

When prompted for credentials, we can input our credentials, and then select skip on the next section, the computer will then restart and be connected to our domain. Now we need some users!

## Creating Users in AD
If we go to Tools, and then Active Directory Users and Computers, we can create managed users that will be able to log in to our domain connected machines. We do this by selecting Users, and then right clicking and selecting New > User. For my first User I figured Jason Bourne would be a lovely employee and my company has given him a great offer he can't refuse. We can enter a name for him, and a username as well. Keep in mind when creating usernames to stick to a naming scheme, his username will be jbourne.
<img width="1356" height="829" alt="Screenshot 2025-12-22 105728" src="https://github.com/user-attachments/assets/8fd381be-f321-4968-ad59-ad4376aacfa6" />

On the next section it will ask to set a password, and will give us some options such as "User must change password on next logon", we want to set an easy temp password to remember, and then when he theoretically logs in for the first time it will ask him to change that to something he wants. We follow that workflow and then we should be able to get a successful login!



