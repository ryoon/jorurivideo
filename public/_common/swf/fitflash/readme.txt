-----------------------------------------------------------------------
//      README FITFLASH (http://fitflash.millermedeiros.com)         //
//   FitFlash is (c) 2006 Miller Medeiros (www.millermedeiros.com)   //
----------------------------------------------------------------------

FitFlash is a smart script that resizes your flash automatically if 
your browser window size is smaller or greater than your flash minimum
desired size keeping it accessible independent of screen resolution.


// What it does?

FitFlash automatically resizes your flash to 100% width and 100% height
when your browser window is greater than the minimum desired size and 
resizes flash to the minimum desired size when the browser window is 
smaller...


// How do i use it?

Include the fitflash.js Javascript file, then just call one simple 
javascript function.


// Example:

<script type="text/javascript" src="fitflash.js" />

<script type="text/javascript">
<!--
FitFlash ("my_flash", 1000, 590);
//-->
</script>


// Arguments:

FitFlash ("flash ID", minWidth, minHeight, maxWidth:optional, maxHeight:optional, centered:optional);

flash ID - The ID of the flash object/embed tag.
minWidth - Minimum desired width (px) for your flash.
minHeight - Minimum desired height (px) for your flash.
maxWidth (optional) - Maximum desired width (px).
maxHeight (optional) - Maximum desired height (px).
centered (optional) - sets if the flash is centered after reach max size, default value is true (true or false).

----------------------------------------------------------------------
// visit http://fitflash.millermedeiros.com for more information..  //
----------------------------------------------------------------------