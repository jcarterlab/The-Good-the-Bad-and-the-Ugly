The Good, the Bad and the Ugly
================
Jack Carter
10/17/2021

## **Summary**

This project shows how the conversation in the New York Times (NYT)
turned for the worse following the 2016 election of Donald Trump. A
strong sense of national belonging is undoubtedly good for any country,
yet Trump’s rise was also accompanied by disinformation, political
polarization, discrimination and the emboldening of extreme groups.
While this data may indicate a decline in some of these trends following
Joe Biden’s 2020 victory, the underlying views of many Trump supporting
Americans who do not read the NYT have likely not changed.

 

## **Method**

**1) Data Collection:**

The data used in this study are collected from the NYT API. They include
metadata that indicate the number of articles containing certain terms
for each year between 2011 and 2021.

<br/>

**2) Z Scores:**

The z scores are calculated as the raw number of articles less the
term’s mean, divided by the term’s standard deviation. This allows for
a comparison of the relative trajectory of terms.

<br/>

**2) Loess Transformation:**

The data for each term is then plotted with the use of a loess
regression line. This smooths out the data points into a curve for a
better visualization of overall trends.

 

## 1\) The Good

![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

## 2\) The Bad

![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-2-2.png)<!-- -->

## 3\) The Ugly

![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->![](The-Good-the-Bad-and-the-Ugly_files/figure-gfm/unnamed-chunk-3-2.png)<!-- -->

 

## **Sources**

  - New York Times (2021) <https://developer.nytimes.com/apis>

  - Statology (2021) <https://www.statology.org/interpret-z-scores/>
