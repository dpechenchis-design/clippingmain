#!/usr/bin/env bash
# Нарізка кліпів. Підстав свої шляхи до відео у SRC_*.
# -ss перед -i = швидкий сік; -c copy ріже по keyframe (±2с!).
# Для точного різу лишено перекодування. Прибери -c:v libx264 ... якщо треба швидко.

SRC_ARDIS="./ardis.mp4"
SRC_WAKEFIELD="./wakefield.mp4"
SRC_GOLER="./goler.mp4"
OUT="./cuts"; mkdir -p "$OUT"

# ARDIS#1 · LOW · And I basically spent the entire seven days trying to pick h
ffmpeg -nostdin -y -ss 112.700 -to 133.160 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_01.mp4"
# ARDIS#2 · LOW · I mean, even Tucker Carlson's reached out to his producer a 
ffmpeg -nostdin -y -ss 188.950 -to 220.000 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_02.mp4"
# ARDIS#3 · LOW–MEDIUM · all of those rights you no longer have because a bat coughed
ffmpeg -nostdin -y -ss 263.700 -to 293.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_03.mp4"
# ARDIS#4 · LOW · uh that just happened to fall at the end of a 4-year tyranni
ffmpeg -nostdin -y -ss 328.973 -to 383.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_04.mp4"
# ARDIS#5 · LOW · Uh that bribe money by the way is called lobbying dollars.
ffmpeg -nostdin -y -ss 394.700 -to 456.640 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_05.mp4"
# ARDIS#6 · MEDIUM–HIGH · So why during COVID 19 when I drop a documentary seen by mil
ffmpeg -nostdin -y -ss 479.700 -to 519.269 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_06.mp4"
# ARDIS#7 · MEDIUM · What you don't know is something big pharma knows about the 
ffmpeg -nostdin -y -ss 541.700 -to 600.000 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_07.mp4"
# ARDIS#8 · HIGH · Oh, now you start to realize, oh, this is why big pharma hat
ffmpeg -nostdin -y -ss 615.700 -to 694.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_08.mp4"
# ARDIS#9 · LOW–MEDIUM · why it was in 1994 they bribed the FDA or blackmailed them.
ffmpeg -nostdin -y -ss 687.700 -to 737.540 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_09.mp4"
# ARDIS#10 · LOW · Oh, the Nightshade vegetable family by the way contains the 
ffmpeg -nostdin -y -ss 738.700 -to 804.714 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_10.mp4"
# ARDIS#11 · LOW · And you should know that in 2016, Harvard published a study 
ffmpeg -nostdin -y -ss 820.740 -to 909.260 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_11.mp4"
# ARDIS#12 · LOW · And they wrote in 2016 that nicotine alone does not cause th
ffmpeg -nostdin -y -ss 901.167 -to 952.750 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_12.mp4"
# ARDIS#13 · LOW · the FDA has the audacity in 2022 to publish once again on it
ffmpeg -nostdin -y -ss 1015.700 -to 1068.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_13.mp4"
# ARDIS#14 · HIGH · And I will just summarize some of the health benefits of nic
ffmpeg -nostdin -y -ss 1085.700 -to 1170.000 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_14.mp4"
# ARDIS#15 · HIGH · How many drugs are prescribed for arthritis? hydroxychloricq
ffmpeg -nostdin -y -ss 1231.033 -to 1291.880 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_15.mp4"
# ARDIS#16 · LOW · You've heard the phrase, 'If we don't study history, we are 
ffmpeg -nostdin -y -ss 1295.700 -to 1359.400 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_16.mp4"
# ARDIS#17 · LOW · So, uh there was a group of scientists sent from the Louie P
ffmpeg -nostdin -y -ss 1360.700 -to 1583.808 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_17.mp4"
# ARDIS#18 · LOW · Okay, so these scientists break down the bean, boil it, smas
ffmpeg -nostdin -y -ss 1620.238 -to 1687.167 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_18.mp4"
# ARDIS#19 · LOW · They decided to name the new chemical molecule version couad
ffmpeg -nostdin -y -ss 1732.950 -to 1759.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_19.mp4"
# ARDIS#20 · LOW · when they isolated the cumorin compound and called it couadi
ffmpeg -nostdin -y -ss 1783.740 -to 1822.357 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_20.mp4"
# ARDIS#21 · LOW · Do you know what was done in 1953? Leen, if you read my book
ffmpeg -nostdin -y -ss 1879.085 -to 1938.160 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_21.mp4"
# ARDIS#22 · LOW · Notice no one's talking about banning eggplants or red tomat
ffmpeg -nostdin -y -ss 1973.700 -to 2018.038 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_22.mp4"
# ARDIS#23 · HIGH · Nicotine alone alone is known to cure over 500 different med
ffmpeg -nostdin -y -ss 2017.700 -to 2048.562 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_23.mp4"
# ARDIS#24 · LOW · I can name 24 drug companies right now who have patents labe
ffmpeg -nostdin -y -ss 2101.367 -to 2181.731 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_24.mp4"
# ARDIS#25 · HIGH · I take number one drug which is called Kituda. It's a cancer
ffmpeg -nostdin -y -ss 2224.777 -to 2319.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_25.mp4"
# ARDIS#26 · HIGH · I take you through all top 10 drugs including HIV drug was n
ffmpeg -nostdin -y -ss 2308.633 -to 2367.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_26.mp4"
# ARDIS#27 · LOW · And just just while we're at date of recording, it's the 22n
ffmpeg -nostdin -y -ss 2367.075 -to 2404.700 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_27.mp4"
# ARDIS#28 · MEDIUM · Please don't let this industry who literally was allowing th
ffmpeg -nostdin -y -ss 2407.557 -to 2468.833 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_28.mp4"
# ARDIS#29 · LOW · They killed my father-in-law in a hospital in February 2020.
ffmpeg -nostdin -y -ss 2499.064 -to 2569.346 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_29.mp4"
# ARDIS#30 · LOW · just in America alone the pharmaceutical industry last year 
ffmpeg -nostdin -y -ss 2557.623 -to 2630.300 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_30.mp4"
# ARDIS#31 · MEDIUM · And for all of you, those that believe in God, shame on you 
ffmpeg -nostdin -y -ss 2713.367 -to 2762.654 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_31.mp4"
# ARDIS#32 · LOW · I went traveling uh through South America and in the States 
ffmpeg -nostdin -y -ss 2791.771 -to 2824.654 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_32.mp4"
# ARDIS#33 · MEDIUM · Yeah. What's an antibiotic? An antibiotic by definition only
ffmpeg -nostdin -y -ss 2826.033 -to 2882.000 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_33.mp4"
# ARDIS#34 · LOW · My father-in-law, as you read in my book, chapter 2, he's di
ffmpeg -nostdin -y -ss 2936.500 -to 3025.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_34.mp4"
# ARDIS#35 · LOW · Um just so you know, to me that is dumbassery. And obviously
ffmpeg -nostdin -y -ss 3052.854 -to 3093.929 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_35.mp4"
# ARDIS#36 · LOW · when your doctor sits down in their office or nurses station
ffmpeg -nostdin -y -ss 3144.486 -to 3201.250 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_36.mp4"
# ARDIS#37 · LOW · I want people to understand that you were very successful in
ffmpeg -nostdin -y -ss 3241.575 -to 3294.750 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_37.mp4"
# ARDIS#38 · LOW · A year and three months later, Laban, my father-in-law walke
ffmpeg -nostdin -y -ss 3310.994 -to 3375.559 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_38.mp4"
# ARDIS#39 · LOW · He actually never tested positive for anything. So they diag
ffmpeg -nostdin -y -ss 3346.854 -to 3400.722 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_39.mp4"
# ARDIS#40 · LOW · We get home that night after visiting hours and within one h
ffmpeg -nostdin -y -ss 3394.200 -to 3487.929 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_40.mp4"
# ARDIS#41 · LOW · Well, I was up there the next morning at 9:00 a.m. By 10:00 
ffmpeg -nostdin -y -ss 3481.450 -to 3515.357 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_41.mp4"
# ARDIS#42 · LOW · He's only doing this because he's obviously being paid by bi
ffmpeg -nostdin -y -ss 3559.343 -to 3605.920 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_42.mp4"
# ARDIS#43 · MEDIUM–HIGH · I just felt this spark literally explode in my body when I r
ffmpeg -nostdin -y -ss 3617.700 -to 3697.062 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_43.mp4"
# ARDIS#44 · LOW · So, I hired a publicist that day, Laban, and told my wife I 
ffmpeg -nostdin -y -ss 3696.262 -to 3794.300 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_44.mp4"
# ARDIS#45 · LOW · In fact, go watch Jurassic Park, the fir the one that just c
ffmpeg -nostdin -y -ss 3837.414 -to 3907.833 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_45.mp4"
# ARDIS#46 · LOW · And if you watched the Olympics last year, you should have b
ffmpeg -nostdin -y -ss 3908.700 -to 3958.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_46.mp4"
# ARDIS#47 · LOW–MEDIUM · Why do you trust all vaccines? Oh, because you watched this 
ffmpeg -nostdin -y -ss 3957.700 -to 3991.000 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_47.mp4"
# ARDIS#48 · LOW · And I challenge you in Australia and around the world, sit d
ffmpeg -nostdin -y -ss 3997.700 -to 4045.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_48.mp4"
# ARDIS#49 · MEDIUM · Nobody has a fever because you're low on Advil.
ffmpeg -nostdin -y -ss 4048.500 -to 4119.300 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_49.mp4"
# ARDIS#50 · HIGH · I wear a nicotine patch of companies for the last three and 
ffmpeg -nostdin -y -ss 4128.575 -to 4190.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_50.mp4"
# ARDIS#51 · HIGH · Every 29 families of variants of the flu virus, there's 29 d
ffmpeg -nostdin -y -ss 4203.220 -to 4274.433 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_51.mp4"
# ARDIS#52 · MEDIUM–HIGH · It's the same reason why all hospitals and medical doctors w
ffmpeg -nostdin -y -ss 4273.633 -to 4340.071 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_52.mp4"
# ARDIS#53 · LOW · Who profits the most from RFK Jr. saying the HHS is going to
ffmpeg -nostdin -y -ss 4380.155 -to 4508.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_53.mp4"
# ARDIS#54 · MEDIUM · Would you like to guess what it is, Leen?
ffmpeg -nostdin -y -ss 4605.700 -to 4653.250 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_54.mp4"
# ARDIS#55 · HIGH · just so you know, oncologists in Europe, in South America, a
ffmpeg -nostdin -y -ss 4665.057 -to 4687.020 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_55.mp4"
# ARDIS#56 · LOW · Brian, what does uh virus translate to in Latin? Do you know
ffmpeg -nostdin -y -ss 4698.433 -to 4759.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_56.mp4"
# ARDIS#57 · LOW · Do you know what a pain in the butt it was in 1771 to print 
ffmpeg -nostdin -y -ss 4758.700 -to 4776.786 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_57.mp4"
# ARDIS#58 · HIGH · 100% of all Latin to English dictionaries translate the word
ffmpeg -nostdin -y -ss 4836.392 -to 4867.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_58.mp4"
# ARDIS#59 · HIGH · When you go to the second half of every one of these books, 
ffmpeg -nostdin -y -ss 4921.700 -to 4977.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_59.mp4"
# ARDIS#60 · MEDIUM–HIGH · if the definition of the word virus in all of them reads a p
ffmpeg -nostdin -y -ss 4990.256 -to 5021.540 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_60.mp4"
# ARDIS#61 · LOW · medicine only uses the Latin language. They are beholding to
ffmpeg -nostdin -y -ss 5031.777 -to 5059.640 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_61.mp4"
# ARDIS#62 · HIGH · My question for you is this, Leen, and I'll leave this with 
ffmpeg -nostdin -y -ss 5054.767 -to 5089.115 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_62.mp4"
# ARDIS#63 · HIGH · How come in three days of chewing four tablets of 2 milligra
ffmpeg -nostdin -y -ss 5095.367 -to 5126.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_63.mp4"
# ARDIS#64 · HIGH · So when people ask me how long are you going to wear a nicot
ffmpeg -nostdin -y -ss 5121.700 -to 5172.375 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_64.mp4"
# ARDIS#65 · LOW · Your government, Australia, the whole government in Australi
ffmpeg -nostdin -y -ss 5287.080 -to 5354.079 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_65.mp4"
# ARDIS#66 · LOW · it's actually intentionally called programming for a reason.
ffmpeg -nostdin -y -ss 5385.600 -to 5413.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_66.mp4"
# ARDIS#67 · LOW · All right. So, uh, what do I know about Laban? All right. So
ffmpeg -nostdin -y -ss 5458.700 -to 5521.833 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_67.mp4"
# ARDIS#68 · LOW · Are you going to go on, Tucker? Was that confirmed?
ffmpeg -nostdin -y -ss 5530.300 -to 5646.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_68.mp4"
# ARDIS#69 · HIGH · Anyway, I just found out that Mel Gibson called his friends 
ffmpeg -nostdin -y -ss 5646.557 -to 5692.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_69.mp4"
# ARDIS#70 · LOW · and I'm going I'm going to her I'm going to their house in S
ffmpeg -nostdin -y -ss 5694.053 -to 5713.500 -i "$SRC_ARDIS" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/ARDIS_70.mp4"
# WAKEFIELD#1 · LOW · in the clinic I can see one child at a time I can help one c
ffmpeg -nostdin -y -ss 125.542 -to 171.880 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_01.mp4"
# WAKEFIELD#2 · LOW · Do you know and I'll be amazed if you don't but I'm I'm glad
ffmpeg -nostdin -y -ss 203.700 -to 244.260 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_02.mp4"
# WAKEFIELD#3 · LOW · And and um the clips from his interview, by the way, have do
ffmpeg -nostdin -y -ss 265.112 -to 290.682 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_03.mp4"
# WAKEFIELD#4 · LOW · And are you still allowed to call yourself doctor or is that
ffmpeg -nostdin -y -ss 319.700 -to 330.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_04.mp4"
# WAKEFIELD#5 · HIGH · Yeah, I'm a a physician. I am also a filmmaker. I graduated 
ffmpeg -nostdin -y -ss 374.138 -to 515.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_05.mp4"
# WAKEFIELD#6 · HIGH · whereas the parents had been told when they went to the psyc
ffmpeg -nostdin -y -ss 473.008 -to 515.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_06.mp4"
# WAKEFIELD#7 · LOW · When you search the name Dr. Andrew Wakefield, there's a ver
ffmpeg -nostdin -y -ss 511.700 -to 542.625 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_07.mp4"
# WAKEFIELD#8 · LOW · uh Rbert Murdoch's son James Murdoch was bored onto the boar
ffmpeg -nostdin -y -ss 600.700 -to 674.731 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_08.mp4"
# WAKEFIELD#9 · LOW · you go on on uh Wikipedia and you look up Andy Wakefield and
ffmpeg -nostdin -y -ss 678.200 -to 705.100 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_09.mp4"
# WAKEFIELD#10 · LOW · there were some dark times. There were really some some dark
ffmpeg -nostdin -y -ss 705.986 -to 757.600 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_10.mp4"
# WAKEFIELD#11 · LOW · And so I became a repository for whistleblowers.
ffmpeg -nostdin -y -ss 813.700 -to 855.278 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_11.mp4"
# WAKEFIELD#12 · LOW · Well, look, I've got some skin in the game here. And I want 
ffmpeg -nostdin -y -ss 851.033 -to 895.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_12.mp4"
# WAKEFIELD#13 · HIGH · Well, it's an interesting story that the MMR came along in t
ffmpeg -nostdin -y -ss 894.700 -to 972.929 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_13.mp4"
# WAKEFIELD#14 · LOW · Well, I'm relying on information from my parents and the sym
ffmpeg -nostdin -y -ss 966.033 -to 1010.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_14.mp4"
# WAKEFIELD#15 · LOW · Well, I then went on to develop gastrointestinal reflux diso
ffmpeg -nostdin -y -ss 1069.085 -to 1114.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_15.mp4"
# WAKEFIELD#16 · HIGH · Now this is because the safety studies were not done before 
ffmpeg -nostdin -y -ss 1247.008 -to 1347.318 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_16.mp4"
# WAKEFIELD#17 · HIGH · Absolutely. I've just literally 5 minutes before coming on w
ffmpeg -nostdin -y -ss 1202.129 -to 1247.808 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_17.mp4"
# WAKEFIELD#18 · HIGH · She said, 'Laben, at best, vaccines do nothing. At worst, th
ffmpeg -nostdin -y -ss 1177.700 -to 1200.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_18.mp4"
# WAKEFIELD#19 · HIGH · current rates of autism are one in is it 31 now?
ffmpeg -nostdin -y -ss 1341.450 -to 1433.357 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_19.mp4"
# WAKEFIELD#20 · HIGH · there's been talk and conversation rumor mill that I've hear
ffmpeg -nostdin -y -ss 1423.700 -to 1511.045 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_20.mp4"
# WAKEFIELD#21 · LOW · At this stage, what they should really do is back off and sa
ffmpeg -nostdin -y -ss 1513.200 -to 1569.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_21.mp4"
# WAKEFIELD#22 · LOW · when my wife and I first got together and I could tell thing
ffmpeg -nostdin -y -ss 1571.641 -to 1660.214 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_22.mp4"
# WAKEFIELD#23 · LOW · The problem is that you can act as an individual. Your wife 
ffmpeg -nostdin -y -ss 1666.100 -to 1766.654 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_23.mp4"
# WAKEFIELD#24 · LOW · when the British Medical Journal and Brian Deer came out wit
ffmpeg -nostdin -y -ss 1785.575 -to 1944.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_24.mp4"
# WAKEFIELD#25 · LOW · I became uh out of necessity very uh well known in my small 
ffmpeg -nostdin -y -ss 1953.012 -to 2086.880 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_25.mp4"
# WAKEFIELD#26 · HIGH · Dell Bigree, who was my producer on Vaxed did a brilliant th
ffmpeg -nostdin -y -ss 2091.200 -to 2227.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_26.mp4"
# WAKEFIELD#27 · LOW · Dell went up to him and sat him down over a meal, bottle of 
ffmpeg -nostdin -y -ss 2226.700 -to 2277.346 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_27.mp4"
# WAKEFIELD#28 · HIGH · 3 and a half thousand people die in this country alone from 
ffmpeg -nostdin -y -ss 2304.129 -to 2357.357 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_28.mp4"
# WAKEFIELD#29 · LOW–MEDIUM · the CDC were given a whole bunch of money to effectively do 
ffmpeg -nostdin -y -ss 2391.700 -to 2458.540 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_29.mp4"
# WAKEFIELD#30 · LOW · when I quit drinking, Andrew, I lost about 99% of my social 
ffmpeg -nostdin -y -ss 2469.700 -to 2520.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_30.mp4"
# WAKEFIELD#31 · HIGH · why don't they test these double blind placebo uh tests on v
ffmpeg -nostdin -y -ss 2547.300 -to 2614.577 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_31.mp4"
# WAKEFIELD#32 · HIGH · I really need to know what I'm talking about... I need to go
ffmpeg -nostdin -y -ss 2623.700 -to 2740.300 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_32.mp4"
# WAKEFIELD#33 · HIGH · There's a a mom who's listening to this right now or her hus
ffmpeg -nostdin -y -ss 2753.700 -to 2876.750 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_33.mp4"
# WAKEFIELD#34 · HIGH · I have two hours free in the next two months. I can squeeze 
ffmpeg -nostdin -y -ss 2879.876 -to 3004.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_34.mp4"
# WAKEFIELD#35 · MEDIUM · I know at least one listener or watcher of this was uh belie
ffmpeg -nostdin -y -ss 3003.700 -to 3103.880 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_35.mp4"
# WAKEFIELD#36 · LOW · The next question I have is around being basically the OG of
ffmpeg -nostdin -y -ss 3106.833 -to 3260.640 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_36.mp4"
# WAKEFIELD#37 · LOW · Who's the one person on planet earth that you would just lov
ffmpeg -nostdin -y -ss 3271.700 -to 3323.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_37.mp4"
# WAKEFIELD#38 · LOW · just relatively recently my social media has uh garnered a t
ffmpeg -nostdin -y -ss 3325.367 -to 3384.300 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_38.mp4"
# WAKEFIELD#39 · LOW · just as a side note for the fact checkers out there the gent
ffmpeg -nostdin -y -ss 3384.700 -to 3433.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_39.mp4"
# WAKEFIELD#40 · LOW · you spend a lot of time, a disproportionate amount of time o
ffmpeg -nostdin -y -ss 3437.450 -to 3485.640 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_40.mp4"
# WAKEFIELD#41 · LOW · I used an a carnivore diet for 3 and 1/2 years to heal a bun
ffmpeg -nostdin -y -ss 3520.644 -to 3620.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_41.mp4"
# WAKEFIELD#42 · LOW · Oh, I was delighted. I was a junior gastronenterologist at t
ffmpeg -nostdin -y -ss 3631.986 -to 3759.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_42.mp4"
# WAKEFIELD#43 · LOW · So you had no no beef with him whatsoever.
ffmpeg -nostdin -y -ss 3744.100 -to 3775.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_43.mp4"
# WAKEFIELD#44 · HIGH · I was invited by Peter McCulla, who's the world's leading ca
ffmpeg -nostdin -y -ss 3793.512 -to 3858.227 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_44.mp4"
# WAKEFIELD#45 · LOW · for me now that will take on a momentum of its own. It's bey
ffmpeg -nostdin -y -ss 3882.582 -to 3942.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_45.mp4"
# WAKEFIELD#46 · LOW · One of the guys I interviewed uh in 20 late 2020 2021 was um
ffmpeg -nostdin -y -ss 3958.825 -to 4040.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_46.mp4"
# WAKEFIELD#47 · LOW · my wife and I have gone through unimaginable challenges. We'
ffmpeg -nostdin -y -ss 4054.700 -to 4102.192 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_47.mp4"
# WAKEFIELD#48 · LOW · parents came to us and said, if I put my child on a diet tha
ffmpeg -nostdin -y -ss 4108.478 -to 4158.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_48.mp4"
# WAKEFIELD#49 · LOW · when I told this to the department of health in a big meetin
ffmpeg -nostdin -y -ss 4158.700 -to 4204.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_49.mp4"
# WAKEFIELD#50 · LOW · I was trying to explain to him in simple terms because he wa
ffmpeg -nostdin -y -ss 4208.647 -to 4248.000 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_50.mp4"
# WAKEFIELD#51 · LOW · I thought for years that I was damaged permanently by my men
ffmpeg -nostdin -y -ss 4342.033 -to 4399.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_51.mp4"
# WAKEFIELD#52 · LOW · gluten is a very particularly in this country where genetica
ffmpeg -nostdin -y -ss 4399.623 -to 4464.920 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_52.mp4"
# WAKEFIELD#53 · LOW · the money on in autism and neurodedevelopmental disorders wa
ffmpeg -nostdin -y -ss 4500.986 -to 4574.056 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_53.mp4"
# WAKEFIELD#54 · LOW · Yeah. I got fired from a job in late 2019.
ffmpeg -nostdin -y -ss 4572.978 -to 4602.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_54.mp4"
# WAKEFIELD#55 · LOW · I would strongly recommend that parents and mothers in parti
ffmpeg -nostdin -y -ss 4641.609 -to 4705.260 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_55.mp4"
# WAKEFIELD#56 · HIGH · Can I very quick question Dr. Indy? Um because of the miscar
ffmpeg -nostdin -y -ss 4783.167 -to 4886.640 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_56.mp4"
# WAKEFIELD#57 · LOW · I know you're no stranger to beautiful women, Andrew.
ffmpeg -nostdin -y -ss 4721.500 -to 4773.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_57.mp4"
# WAKEFIELD#58 · MEDIUM–HIGH · Cuz I was like I don't want really to take it but they may b
ffmpeg -nostdin -y -ss 4888.437 -to 4901.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_58.mp4"
# WAKEFIELD#59 · LOW · Where does it come from? Lean.
ffmpeg -nostdin -y -ss 4941.843 -to 4962.880 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_59.mp4"
# WAKEFIELD#60 · LOW · Ladies and gentlemen, uh Andy Wakefield here from Texas.
ffmpeg -nostdin -y -ss 5004.840 -to 5057.429 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_60.mp4"
# WAKEFIELD#61 · LOW · in the end it comes down to raising the kind of money that y
ffmpeg -nostdin -y -ss 5069.700 -to 5118.409 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_61.mp4"
# WAKEFIELD#62 · LOW · do do you have any connection to to Mel Gibson
ffmpeg -nostdin -y -ss 5112.085 -to 5184.038 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_62.mp4"
# WAKEFIELD#63 · LOW · There's a Taylor, you know, Taylor Sheridan. That would be— 
ffmpeg -nostdin -y -ss 5180.950 -to 5211.763 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_63.mp4"
# WAKEFIELD#64 · LOW · there's a great quote that I got from a mentor of mine, Les 
ffmpeg -nostdin -y -ss 5211.595 -to 5241.500 -i "$SRC_WAKEFIELD" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/WAKEFIELD_64.mp4"
# GOLER#1 · LOW · Yeah. And the relevance of this question is that my wife and
ffmpeg -nostdin -y -ss 564.700 -to 610.060 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_01.mp4"
# GOLER#2 · LOW · 
ffmpeg -nostdin -y -ss 604.700 -to 610.060 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_02.mp4"
# GOLER#3 · LOW · Yeah. And uh when you're saying give them all the things tha
ffmpeg -nostdin -y -ss 980.700 -to 995.880 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_03.mp4"
# GOLER#4 · LOW · Yeah, I uh it was a bit of a loaded question because I I in 
ffmpeg -nostdin -y -ss 1069.700 -to 1094.900 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_04.mp4"
# GOLER#5 · LOW · And if people are just dialing in and they're like, \
ffmpeg -nostdin -y -ss 1094.100 -to 1128.938 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_05.mp4"
# GOLER#6 · LOW · Yeah. And you're very humble, Danny. Uh, and I don't I'm not
ffmpeg -nostdin -y -ss 1273.700 -to 1336.260 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_06.mp4"
# GOLER#7 · LOW · The uh one of the Oh, man. I I've I've been consuming uh pro
ffmpeg -nostdin -y -ss 1739.700 -to 1787.500 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_07.mp4"
# GOLER#8 · LOW · becoming the person in order to, right? And this and this ti
ffmpeg -nostdin -y -ss 1783.700 -to 1825.100 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_08.mp4"
# GOLER#9 · LOW · but to to to get to the point of kind of what I'm talking ab
ffmpeg -nostdin -y -ss 1826.384 -to 1878.920 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_09.mp4"
# GOLER#10 · LOW · There's a couple of things, Danny, that come to me just goin
ffmpeg -nostdin -y -ss 2366.700 -to 2417.731 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_10.mp4"
# GOLER#11 · LOW · My first ever experience with even hearing about DMT was pro
ffmpeg -nostdin -y -ss 2416.931 -to 2464.060 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_11.mp4"
# GOLER#12 · LOW · I uh I inextricably started running uh out of the blue in 20
ffmpeg -nostdin -y -ss 2760.486 -to 2781.562 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_12.mp4"
# GOLER#13 · LOW · 
ffmpeg -nostdin -y -ss 2753.700 -to 2806.625 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_13.mp4"
# GOLER#14 · LOW · And I often hypothesize and I've spoken to a number of brill
ffmpeg -nostdin -y -ss 2798.500 -to 2850.312 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_14.mp4"
# GOLER#15 · LOW · Well uh so my my first marathon which I did in 2018 which wa
ffmpeg -nostdin -y -ss 2862.080 -to 2941.640 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_15.mp4"
# GOLER#16 · LOW · And I and I shifted 60 lbs of body fat over two years, Danny
ffmpeg -nostdin -y -ss 2952.759 -to 2981.429 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_16.mp4"
# GOLER#17 · LOW · 
ffmpeg -nostdin -y -ss 2973.700 -to 3020.000 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_17.mp4"
# GOLER#18 · LOW · So uh 10 10 to 12 kilometers. So like 7 to 8 miles in right.
ffmpeg -nostdin -y -ss 3015.700 -to 3041.000 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_18.mp4"
# GOLER#19 · LOW · 
ffmpeg -nostdin -y -ss 3250.700 -to 3257.500 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_19.mp4"
# GOLER#20 · LOW · And there's one other component. Um the in the in the ketone
ffmpeg -nostdin -y -ss 3367.700 -to 3398.880 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_20.mp4"
# GOLER#21 · LOW–MEDIUM · I even I self-experimented a lot. I ran a 30 mile in 2021 in
ffmpeg -nostdin -y -ss 3416.033 -to 3505.500 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_21.mp4"
# GOLER#22 · LOW · during CO in the early stages of CO I did purely beef water 
ffmpeg -nostdin -y -ss 3498.582 -to 3534.100 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_22.mp4"
# GOLER#23 · LOW · And I know a lot of the, you know, norepinephrine, dopamine,
ffmpeg -nostdin -y -ss 3520.700 -to 3543.346 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_23.mp4"
# GOLER#24 · LOW · And then doing a a powerful penis envy psilocybin uh journey
ffmpeg -nostdin -y -ss 3542.546 -to 3588.440 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_24.mp4"
# GOLER#25 · LOW · I remember what triggered this, Danny. And it was a text mes
ffmpeg -nostdin -y -ss 3736.360 -to 3935.357 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_25.mp4"
# GOLER#26 · LOW · I mean I've played sport never at a competitive level. I pla
ffmpeg -nostdin -y -ss 3931.700 -to 3986.500 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_26.mp4"
# GOLER#27 · LOW · the the first 100 kilometer that I did the 60 mileer, I inju
ffmpeg -nostdin -y -ss 3971.117 -to 4038.500 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_27.mp4"
# GOLER#28 · LOW · 
ffmpeg -nostdin -y -ss 4032.700 -to 4054.540 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_28.mp4"
# GOLER#29 · LOW · people are going to have a hard time uh believing that and I
ffmpeg -nostdin -y -ss 4294.700 -to 4345.000 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_29.mp4"
# GOLER#30 · LOW · 
ffmpeg -nostdin -y -ss 4344.700 -to 4409.020 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_30.mp4"
# GOLER#31 · ? · A lot of this comes from while you're doing that um exhausti
ffmpeg -nostdin -y -ss 4412.700 -to 4465.500 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_31.mp4"
# GOLER#32 · LOW–MEDIUM · Well, I think Jod Spence is a great example uh for those who
ffmpeg -nostdin -y -ss 4491.840 -to 4630.500 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_32.mp4"
# GOLER#33 · ? · ...we've had 20 miscarriages
ffmpeg -nostdin -y -ss 4628.546 -to 4773.260 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_33.mp4"
# GOLER#34 · LOW · Yeah, I think I think a lot of it comes down to um from my o
ffmpeg -nostdin -y -ss 4827.700 -to 4889.143 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_34.mp4"
# GOLER#35 · ? · And some people say, \
ffmpeg -nostdin -y -ss 4884.771 -to 4928.269 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_35.mp4"
# GOLER#36 · LOW · 
ffmpeg -nostdin -y -ss 4926.700 -to 4957.300 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_36.mp4"
# GOLER#37 · LOW · It's beautiful. Beautiful. Daniel and speaking of divine to 
ffmpeg -nostdin -y -ss 5133.700 -to 5165.680 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_37.mp4"
# GOLER#38 · LOW · 
ffmpeg -nostdin -y -ss 5993.700 -to 6013.260 -i "$SRC_GOLER" -c:v libx264 -crf 18 -preset veryfast -c:a aac "$OUT/GOLER_38.mp4"
