#!/bin/bash
# Daniel Ballesteros-Chávez
# Usage: ./gentab_gamma.sh

## This is a static site generator
## I will be using only 2 csv files.
## The html template was generated by Emacs org.



# FILE1=$"xo_ENSU_TS.csv"
# FILE2=$"xo_HOM_TS.csv"

# FILENAME=$"xochitl.html"

#rm "${FILENAME}"

# FILE2=$2

# Number of rows in $FILE
# ROWS=$(cat $FILE | wc -l)

# TITLE2=$(awk -F"," 'NR==2 {print $22}' $FILE | tr -d '"')
# TITLE3=$(awk -F"," 'NR==2 {print $23}' $FILE | tr -d '"')
# #TITLE2="This is just an Example 00"

# TITLE="${TITLE:=Título: $TITLE2}"


# export FILE1
# export FILE2

# ## ------ R code for Plot01: bar plot

Rscript -e '
df  <- read.csv("xo_ENSU_TS.csv")
head(df)

df[, c( "Inseguro", "Inseguro_H", "Inseguro_M")] <- round(df[, c( "Inseguro", "Inseguro_H", "Inseguro_M")],2)

# library(tidyquant)
library(plotly)

# tickers = c("Nacional", "Hombres", "Mujeres")

fig <- plot_ly(df, type = "scatter", mode = "lines")%>%

   add_trace(x = ~Dates, y = ~Inseguro, name = "Nacional")%>%

  add_trace(x = ~Dates, y = ~Inseguro_H, name = "Hombres")%>%

  add_trace(x = ~Dates, y = ~Inseguro_M, name = "Mujeres")%>%

  layout(title = "ENSU Time Series",legend=list(title=list(text="variable")),

##         xaxis = list(dtick = "M1", tickformat="%b\n%Y", ticklabelmode="period"), 

### width = 1000

autosize = TRUE
)

options(warn = -1)

fig <- fig %>%

  layout(

         xaxis = list(zerolinecolor = "#ffff",

                      zerolinewidth = 2,

                      gridcolor = "ffff"),

         yaxis = list(zerolinecolor = "#ffff",

                      zerolinewidth = 2,

                      gridcolor = "ffff"), plot_bgcolor="#E5E5E5"
) 


fig

htmlwidgets::saveWidget(as_widget(fig),selfcontained=FALSE, "xo_ENSU_TS.html")
'

# ## ------ R code for Table02
Rscript -e '
print("Now we are generating the Table 02")

library(plotly)
df  <- read.csv("xo_ENSU_TS.csv")

df[, c( "Inseguro", "Inseguro_H", "Inseguro_M")] <- round(df[, c( "Inseguro", "Inseguro_H", "Inseguro_M")] ,2)

df <- df[, c("Dates", "Inseguro", "Inseguro_H", "Inseguro_M")]


fig <- plot_ly(

  type = "table",

  header = list(

  values = c(names(df)),

  align = c("left", "center","center", "center"),

  fill = list(color = "rgb(218, 218, 218)"),

  font = list(family = "Mono", size = 14, color = "grey20")  ),

  cells = list(

    values = rbind(t(df)),

    align = c("left", "center","center", "center"),

    line = list(color = "black", width = 1),

    fill = list(color = c("#BFD5E3", "#E5E5E5")),

    font = list(family = "Mono", size = 12, color = c("#404040"))

  ))

fig
htmlwidgets::saveWidget(as_widget(fig),selfcontained=FALSE, "xo_ENSU_Tab.html")
'

Rscript -e '

df  <- read.csv("xo_HOM_TS.csv")
head(df)


#library(tidyquant)
library(plotly)

# tickers = c("Nacional", "Hombres", "Mujeres")

fig <- plot_ly(df, type = "scatter", mode = "lines")%>%

   add_trace(x = ~Dates, y = ~Homicides, name = "Homicidios")%>%

  add_trace(x = ~Dates, y = ~Feminicidio, name = "Feminicidios")%>%


  layout(title = "Homicides Time Series",legend=list(title=list(text="variable")),

##         xaxis = list(dtick = "M1", tickformat="%b\n%Y", ticklabelmode="period"), 

### width = 1000

autosize = TRUE
)

options(warn = -1)

fig <- fig %>%

  layout(

         xaxis = list(zerolinecolor = "#ffff",

                      zerolinewidth = 2,

                      gridcolor = "ffff"),

         yaxis = list(zerolinecolor = "#ffff",

                      zerolinewidth = 2,

                      gridcolor = "ffff"), plot_bgcolor = "#E5E5E5")



fig

htmlwidgets::saveWidget(as_widget(fig),selfcontained=FALSE, "xo_HOM_TS.html")
'
# ## ------ R code for Table02
Rscript -e '
print("Now we are generating the Table 02")

library(plotly)
df  <- read.csv("xo_HOM_TS.csv")

df <- df[, c("Dates", "Homicides", "Feminicidio")]


fig <- plot_ly(

  type = "table",

  header = list(

  values = c(names(df)),

  align = c("left", "center","center", "center"),

  line = list(width = 1, color = "black"),

  fill = list(color = "rgb(218, 218, 218)"),

  font = list(family = "Mono", size = 14, color = "grey20")

  ),

  cells = list(

    values = rbind(t(df)),

    align = c("left", "center","center", "center"),

    line = list(color = "black", width = 1),

    fill = list(color = c("#BFD5E3", "#E5E5E5")),

    font = list(family = "Mono", size = 12, color = c("#404040"))

  ))

fig
htmlwidgets::saveWidget(as_widget(fig),selfcontained=FALSE, "xo_HOM_Tab.html")
'

# ## World map
# Rscript -e '
# print("Now we are generating the country map")
# FILE <- Sys.getenv("FILE")   

# library(plotly)
# df.mx <- read.csv(FILE)
# df <- read.csv("https://raw.githubusercontent.com/plotly/datasets/master/2014_world_gdp_with_codes.csv")
# df$NOTSAFE <- 0
# df[df$CODE%in%"MEX",]$NOTSAFE <- round(df.mx[df.mx$LEVELS.mean%in%"Nacional",]$VALUE.mean[2],2)

# fig <- plot_ly(df, type="choropleth", locations=df$CODE, z=df$NOTSAFE, text=df$COUNTRY, colorscale="Purples") #, reversescale=TRUE)
# fig
# htmlwidgets::saveWidget(as_widget(fig),selfcontained=FALSE, "map01.html")
# '


emacs --batch --eval "(require 'org)" myTSmx.org --funcall org-html-export-to-html
emacs --batch --eval "(require 'org)" myTSmx_ES.org --funcall org-html-export-to-html
