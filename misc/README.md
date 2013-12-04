restlessnapkin
================

This app was built off of Pokle's sinatra-bootstrap

In its current form, it's a hodgepodge of the original version of the bar ordering application and its current iteration of a street vendor mobile ordering and payment application. Once everything is working, I plan to reorganize the code to focus mainly on the current iteration and strip away all the bar ordering code into an archive within the app to make working on the current iteration easier.

Thinks that need to get done before launch:

   * Checkout Pill with total number of items

      * Eddie has this initial piece working backwards, modifying code to work properly

   * Need to convert javascript variables to ruby for passage to stripe

      * Eddie to make this happen

         * Total
         * Total in pennies
         * Line items with quantity, name and price


   * Build out order confirmation page

      * Copy from original bar page

   * Build checkin with texting >> name request >> order

      * Might not need name, could be on credit card
      * Pull code from original checkin

   * Stripe Connect needs to be tested and implemented
   * Receipt Printer

      * Authorize printer
      * Post to printer
      * Only show menu when printer is active and post if active

         * If not active, list phone number to venue

      * Mark as received when printer prints payload

