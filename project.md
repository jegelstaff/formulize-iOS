
CURRENT iOS VERSION 
=======================
---
### 1. Add and store connections 
- User can enter and save the information before logging into a site by filling the add connection form. The information are:
    - site URL (required)
    - site description (optional)
    - username (optional)
    - password (optional)  
- user can choose to enter the username and/or password or not.  
- The data are save to the database to insure that the data will be kept after terminating the app.  

### 2. Delete existing connections
- User can delete a existing site by clicking the edit button in the connection tableView. Then touching the (-) sign and deleting the desired table cell. The delete action cannot be undone.

### 3. URL and User credentials Validation    
1. When user chooses a site to login, first, the URL is tested to see if it exists. If URL exists, check for user credentials; otherwise, display "Invalid URL" alert box.  
2. If username and password are saved, use them to connect directly to the site. Otherwise, pop a Login dialog box for the user to enter username/password. Login button int the dialog box is enabled only if user enters both username and password. Once user click login, application attempts to connect to the site.  
3. When connecting to the site, if user credentials are valid, connection is successful. If not, display "Invalid Login" alert box.  

### 4. Display applications and Menu Links Lists   
- When login is successful, If the user has a permission to any menuLinks, a list of the applications to which these links belong to is displayed in the Application tableView. Otherwise, an alertbox is displayed and user will not be moved to the Applications tableView. 
- When one or more application is displayed, if user chooses an application, a list of the related menu Links is shown. 
- The applications and Menu Links are sent from the server as JSON-formatted data upon a request to the app_list.php file created by Tim for the Android-app.

### 5. Handling external links  
- When choosing a menu item that contains a link to an external URL, the application opens the URL in a web browser.

### 6. Handling multiple connections 
- When a user logs in to a site, the user does not have to login agian as long as that connection ia alive. If the user goes back to the connections tableView, the user can login to another site and have both connections  
active concurrently.  
  
.
ON PROGRESS
=============
---
### 1. Edit existing connections
### 2. Keeping a connection alive  
### 3. Handling screen-type menu links
  
.  

TO DO
=====
---
