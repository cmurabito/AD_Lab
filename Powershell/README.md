# Powershell
Many routine tasks in Active Directory can be automated through the use of powershell. Powershell is a powerful object oriented language that is imperative and highly functional. So what kind of things can we do with it? We can easily output a list of all the users in our domain if we wanted to using "Get-ADUser".

<img width="1020" height="763" alt="Screenshot 2026-02-01 174409" src="https://github.com/user-attachments/assets/c35d2d19-7296-49ae-af1c-2a1b21609268" />

"Get-ADUser" is what is known as a cmdlet. Cmdlets are designed to perform functions and they typically follow a consistent "Verb-Noun" naming process. We can grab a list of these cmdlets by inputting "Get-Command" into a powershell window. We can also find more information about them by using "Get-Help <command-name>". Also, we can refer to a google search easily and research these cmdlets further through the microsoft documentation.

<img width="853" height="876" alt="Screenshot 2026-02-01 174001" src="https://github.com/user-attachments/assets/d5afc63c-44e1-4aac-8963-7b2d8c7f5d84" />

Above we have the different flags that we can pair with the "Get-ADUser" cmdlet to achieve different results. We can also "pipe" these cmdlets into other cmdlets or functions to achieve a desired result. Say we wanted to take the output from "Get-ADUser" and put it into an excel file or a .csv, we would add a "|" inbetween cmdlets to achieve something like this.

<img width="786" height="40" alt="Screenshot 2026-02-01 175138" src="https://github.com/user-attachments/assets/5cdd0ee0-bccf-4b72-8344-7e18bfa06648" />

If we then opened this file in a program like excel, this is how it would turn out. This output is somewhat readable and could be referenced back to in the case of something like a security audit.

<img width="1018" height="755" alt="Screenshot 2026-02-01 180012" src="https://github.com/user-attachments/assets/c2057105-cd9d-4549-bb08-d9bd01ceecc9" />

Another important cmdlet and example would be "Get-ADGroupMember". This cmdlet can show us which members are part of which groups, such as users, computers, and other groups. It also can fetch us details such as SID numbers and the classes of objects.

<img width="1020" height="762" alt="Screenshot 2026-02-01 174754" src="https://github.com/user-attachments/assets/7545d7f9-9d29-4f9e-b5f3-eeb95fb34bb8" />

These are just two examples of Powershell cmdlets. We can also write powershell scripts, create custom cmdlets as advanced functions, and so much more. This is just an introduction into a couple of things we can do with this powerful language so I won't be getting into too much of it here. If powershell is something that piques your interest I highly recommend taking a look at Microsoft's [powershell documentation](https://learn.microsoft.com/en-us/powershell/), as it will be a useful skill within the field of Information Technology. My automation for this lab will be documented through the Scripts directory and how they are implemented through the main AD_Lab directory and I encourage checking them out there as they are updated!
