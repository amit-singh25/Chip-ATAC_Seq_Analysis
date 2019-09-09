setwd("~/peak_folder/")
###load peak file from homer anotate 
peak<-read.delim("list_peak.txt",header=T,sep=",")

library( hwriter )
### All individual gene covergae from TSS +/-2000 are stored in images folder with .png format 
page <- openPage("Annotate_peak_profile.html",
                  head = paste( sep="\n",
                                "<script>",
                                "   function set_image( name ) {",
                                "      document.getElementById( 'plot' ).setAttribute( 'src', 'images/' + name + '.png' );",
                                "   }",
                                "</script>" ) )
cat(file=page,
    '<table><tr><td style="vertical-align:top"><div style="height:800px; overflow-y:scroll">' )

##### write correspondense to gene id or symbol
hwrite(peak, border=NULL, page=page,
       onmouseover = sprintf( "set_image( '%s' );", peak$ens.id ) )
cat( file=page,
     '</div></td><td style="vertical-align:top"><img id="plot" width="600px"></td></tr></table>' )
closePage(page)
browseURL( "Annotate_peak_profile.html" )
