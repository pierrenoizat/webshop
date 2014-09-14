##microbitcoin
Micro webshop accepting payments in bitcoins and other payment options. 

I developped microbitcoin.net in RoR (Rails 3) starting from Dave Thomas awesome tutorial "Agile Web Development in Rails". It shows a bitcoin cart/checkout (allowing other payment methods) with email notification, bitcoin uri qrcode, pdf invoice download etc.. 

A new bitcoin address is generated for each transaction. 

The app comes with full admin capability to create and update a product catalog. 

I integrated a deterministic bitcoin wallet so that the shopkeeper can use a regular electrum wallet to watch payments while the web server is not holding any private key. The seed of the electrum wallet can be safely kept offline.The app knows only the master public key of the wallet to generate bitcoin addresses: this is the safest option for a webshop accepting bitcoin payments.

###Who should use microbitcoin?

Small webshop selling physical goods (sales of digital goods are not yet supported: see TO DO), blogger, event organizer,etc.

###Main features:
* Product catalog with full admin capabilities: create products with pictures, update prices, etc.. Prices are set in bitcoin or EUR indifferently and shippig costs are set in fiat currency (e.g. euros). Amounts are displayed both in fiat currency and bitcoins.
* Two-step check out: shipping details form, invoice. No sign up is required.
* Bitcoin invoice: a new bitcoin address is generated for each invoice, using an electrum wallet master public key. This feature uses Pavol Rusnak's 'bitcoin-addrgen' gem.
* PDF invoice: a pdf invoice is generated and can be downloaded by the customer at the time of order. If payment in bitcoin was selected, the pdf includes the bitcoin uri qrcode.
* email notifications upon order and payment received (using blockchain.info API).
* Product photo carousel
* Javascript cart in side bar
* Sidebar navigation with custom css (no bootstrap).
* Static pages: FAQ, Shipping conditions, etc
* Locale switch (flags)
* No third party service is called except blockchain.info for payment receive notifications and bitcoincharts for current exchange rate. Default rate can be set in config file.

###Usage
1.	Download and install your electrum wallet application from electrum.org Install Rails 3 (upgrade to Rails 4 is on the TO DO list) Install postgreSQL database
2.	$ git clone https://github.com/pierrenoizat/webshop.git
3.	$ bundle install
4.	Edit config/application.rb file to enter your own electrum wallet master public key (export master public key from your electrum wallet) as $MPK global variable.
5.	Edit user.rb to change "wibble" by any random string of your choice in Digest::SHA2.hexdigest(password + "wibble" + salt)
6.	Edit config/environments/development.rb and production.rb to enter your own gmail password.
7.	Comment out the following line if you want to have emails delivered in development: config.actionmailer.performdeliveries = false
8.	Edit db/seeds.rb to enter your user name and password for the postgreSQL database in user = User.create(:name => "Pierre", :password => "password", :password_confirmation => "password")
9.	$ rake db:setup
10.	$ rails server
11.	Visit http://localhost:3000, start browsing the catalog and shopping.. Fork the code to go after the TO DO features.

###TO DO:
•	pretty css or css with bootstrap

•	add instant payment receive notification to sell digital goods (download links).

•	develop test

•	make javascript work with IE. Some visual effects are not displayed properly with IE while they work fine with real web browsers like Firefox, Chrome or Safari.


•	add quantity increment/decrement to cart functionnality. Right now only "add one to cart" and "empty cart" buttons are present.

•	add bank card payment option and easy payment gateway integration. Right now only bitcoins and checks appear in the payment option list.

•	display VAT amount in invoices

•	develop an audit server that will periodically visit the shop to generate a bitcoin address: the audit server can then check that the address belongs to the wallet and send an alert if there is a mismatch. The audit server needs only the master public key of the wallet. The audit server makes it harder to tamper with the payment addresses: both the audit server and the webshop app server must be compromised simultaneously to tamper with the master public key, Right now, the security check can be performed manually by the shop keeper or by the shopper using bitcoinrad.io (another web app I developped as a security feature: see bitcoinrad.io website).

•	Update to Rails 4

###More on preventing man-in-the-middle attacks
Publish the master public key on several social networks and key servers: this will allow your customers to check that the address belongs to you before paying your invoice (see <http://bitcoinrad.io> for details). 

This is not a requirement but its a sure and simple way to mitigate the risk of a man-in-the-middle attack on your bitcoin payment addresses. Knowing your master public key will allow also the taxman and your competitors to track your bitcoin revenues but this is the price to pay for ultimate security. 

Bear in mind that your bitcoin sales are probably only a fraction of your sales since you offer several payment options. 

If you are not comfortable with this level of transparency, then the audit server (see TO DO list) keeps your bitcoin sales figures private while achieving ultimate security at the cost of an additionnal server.

###Thanks to
Matej Danter,
David Heinemeier Hansson,
Sam Ruby,
Pavol Rusnak,
Chris Savery,
Dave Thomas.

Donations welcome to 14EEEdn7fVBCYawkEAdcjqnKbxvejoZAT9. Donations help me cover the costs of hosting microbitcoin.net.

###Licence
AGPL License. Copyright 2011-2014 Pierre NOIZAT
