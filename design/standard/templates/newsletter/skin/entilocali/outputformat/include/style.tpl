<style type="text/css">
{literal} 
    /* Outlook 07, 10 Padding issue fix */
    table td {border-collapse: collapse;}
    /***************************************************
    MOBILE TARGETING
    ***************************************************/
    @media only screen and (max-device-width: 480px) {
      /* Part one of controlling phone number linking for mobile. */
      a[href^="tel"], a[href^="sms"] {
            text-decoration: none;
            color: #006699; /* or whatever your want */
            pointer-events: none;
            cursor: default;
          }
      .mobile_link a[href^="tel"], .mobile_link a[href^="sms"] {
            text-decoration: default;
            color: #006699 !important;
            pointer-events: auto;
            cursor: default;
          }
    }
    /* More Specific Targeting */

    @media only screen and (min-device-width: 768px) and (max-device-width: 1024px) {
    /* You guessed it, ipad (tablets, smaller screens, etc) */
      /* repeating for the ipad */
      a[href^="tel"], a[href^="sms"] {
            text-decoration: none;
            color: #006699; /* or whatever your want */
            pointer-events: none;
            cursor: default;
          }

      .mobile_link a[href^="tel"], .mobile_link a[href^="sms"] {
            text-decoration: default;
            color: #006699 !important;
            pointer-events: auto;
            cursor: default;
          }
    }

    @media only screen and (-webkit-min-device-pixel-ratio: 2) {
    /* Put your iPhone 4g styles in here */ 
    }

    /* Android targeting */
    @media only screen and (-webkit-device-pixel-ratio:.75){
    /* Put CSS for low density (ldpi) Android layouts in here */
    }
    @media only screen and (-webkit-device-pixel-ratio:1){
    /* Put CSS for medium density (mdpi) Android layouts in here */
    }
    @media only screen and (-webkit-device-pixel-ratio:1.5){
    /* Put CSS for high density (hdpi) Android layouts in here */
    }
    /* end Android targeting */

  /***********************************************
  END MOBILE TARGETING
  ************************************************/
{/literal}
  </style>