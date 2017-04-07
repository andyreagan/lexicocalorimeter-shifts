# stealing.sh
# use a local webserver to generate and capture all of the shifts
#
# note: use node http-server (python SimpleHTTPServer will fail)

########################################
for STATE in AL AZ AR CA CO CT DE DC FL GA ID IL IN IA KS KY LA ME MD MA MI MN MS MO MT NE NV NH NJ NM NY NC ND OH OK OR PA RI SC SD TN TX UT VT VA WA WV WI WY;
# ["AL","AZ","AR","CA","CO","CT","DE","DC","FL","GA","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY"]
do
    ### Part 1: grab the SVG's ###
    # echo "http://panometer.org/instruments/lexicocalorimeter/?state=$STATE"
    # # take the first one
    # phantomjs my-crowbar.js "http://panometer.org/instruments/lexicocalorimeter/?state=$STATE" "foodshift" "svg/$STATE-food.svg"
    # sleep .01
    # phantomjs my-crowbar.js "http://panometer.org/instruments/lexicocalorimeter/?state=$STATE" "activityshift" "svg/$STATE-activity.svg"
    # sleep .01
    for WORDS in posup # posdown negup negdown
    do
        echo "http://panometer.org/instruments/lexicocalorimeter/state=$STATE&wordtypes=$WORDS"
        phantomjs my-crowbar.js "http://panometer.org/instruments/lexicocalorimeter/?state=${STATE}&wordtypes=${WORDS}" "foodshift" "svg/$STATE-food-$WORDS.svg"
        sleep .01
        phantomjs my-crowbar.js "http://panometer.org/instruments/lexicocalorimeter/?state=${STATE}&wordtypes=${WORDS}" "activityshift" "svg/$STATE-activity-$WORDS.svg"
        sleep .01
    done

    ### Part 2: print to PDF ###
    for FLUX in food activity;
    do
        # DEBUG=electron-html-to,electron-html-to:* node pdfify.js shift01-random.svg shift01-random.pdf
        # node pdfify.js svg/$STATE-$FLUX.svg pdf/$STATE-$FLUX.pdf
        for WORDS in posup # posdown negup negdown
        do
            node pdfify.js svg/$STATE-$FLUX-$WORDS.svg pdf/$STATE-$FLUX-$WORDS.pdf
        done
    done

    ### Part 2: Crop (twice) ###
    for FLUX in food activity;
    do
        # DEBUG=electron-html-to,electron-html-to:* node pdfify.js shift01-random.svg shift01-random.pdf
        # pdfcrop pdf/$STATE-$FLUX.pdf
        # ~/tools/shell/kitchentabletools/pdfcrop-specific.pl pdf/$STATE-$FLUX-crop.pdf
        for WORDS in posup # posdown negup negdown
        do
            pdfcrop pdf/$STATE-$FLUX-$WORDS.pdf
            ~/tools/shell/kitchentabletools/pdfcrop-specific.pl pdf/$STATE-$FLUX-$WORDS-crop.pdf
        done
    done
    
done


