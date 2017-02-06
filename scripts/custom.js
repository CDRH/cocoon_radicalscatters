 $(document).ready(function () {


// Change the spans from note-nojavascript (in cast js is turned off) to note-invisible
//$('#mainContent > p > span').removeClass('note-nojavascript').addClass('note-invisible');

$('a[@class=footnote] + span').removeClass('note-nojavascript').addClass('note-invisible');


                        
                        
// Expand only the active menu, which is determined by the class name
$("#menu > li > a[@class=expanded] ").find("+ ul").slideToggle("medium");
                        
// Toggle the selected menu's class and expand or collapse the menu
$("#menu > li > a").click(function () {
    $(this).toggleClass("expanded").toggleClass("collapsed").find("+ ul").slideToggle("medium");
    return false;
    });
    
    
$('a[@class=footnote]').click(function () {
    $(this).find("+ span").toggleClass('note-invisible').toggleClass('note-visible');
    return false;
});
                            
                            
                            
                        
                            
                      
      
                          
                        
                        
                    });
                    
                    