#!/bin/bash


#for movies
#finds new files (mp4, avi, mkv - not srt) w/in Movie folder created w/in last 24hrs (-atime)
cd /mnt/user/Media/media/movies
find . -atime -1 -type f ! -name "*.srt" | cut -c 3- > /mnt/user/Media/complete/new_movie.txt
list_mov_var=$(cat /mnt/user/Media/complete/new_movie.txt)

if [ $(wc -c < /mnt/user/Media/complete/new_movie.txt) -eq 0 ]; then
    # else filename does not exist or is zero length
    echo "no new movies"
else
    #if filename exists and is > 0 bytes
    #using unraid's notification system, will email the list of new movies - needs to be setup within unraid
    #I use Radarr for Movie downloading, not needed but adds to customization
    /usr/local/emhttp/webGui/scripts/notify -e Radarr -s "Radarr - New Movie(s) Downloaded!" -d "New media detected in /mnt/user/Media/media/movies" -m "$list_mov_var" -t
fi

sleep 5
rm /mnt/user/Media/complete/new_movie.txt



#for tv shows
#finds new files (mp4, avi, mkv - not srt) w/in TV Show folder created w/in last 24hrs (-atime)
cd /mnt/user/Media/media/tv
find . -atime -1 -type f ! -name "*.srt" | cut -c 3- > /mnt/user/Media/complete/new_tv.txt
list_tv_var=$(cat /mnt/user/Media/complete/new_tv.txt)

if [ $(wc -c < /mnt/user/Media/complete/new_tv.txt) -eq 0 ]; then
    # else filename does not exist or is zero length
    echo "no new tv shows"
else
    #if filename exists and is > 0 bytes
    #using unraid's notification system, will email the list of new tv shows - needs to be setup within unraid
    #I use Sonarr for TV Show downloading, not needed but adds to customization
    /usr/local/emhttp/webGui/scripts/notify -e Sonarr -s "Sonarr - New TV Shows(s) Downloaded!" -d "New media detected in /mnt/user/Media/media/tv" -m "$list_tv_var" -t
fi

sleep 5
rm /mnt/user/Media/complete/new_tv.txt


#checks if any files are in the COMPLETE folder which could indicate stuck files
#sometimes Radarr/Sonarr fail importing a downloaded/complete file. Wanted a notification in this event.
if [ -n "$(ls -A /mnt/user/Media/complete 2>/dev/null)" ]; then
    /usr/local/emhttp/webGui/scripts/notify -s "Files in COMPLETE Folder" -d "Files deteced in the /mnt/user/Media/complete, possibly stuck" -m "RADARR/SONARR may not have properly imported new media. Please check the /mnt/user/Media/complete folder and resolve the issue." -t
fi


# Generates updated list of number of movie file type and another list of all movies titles.
# Outputs file with number of each type of file within Movies directory
cd /mnt/user/Media/media/movies
echo '::Number of each file type::' > /mnt/user/Media/media/MovieList_FileTypes.txt
echo  >> /mnt/user/Media/media/MovieList_FileTypes.txt
find . -type f ! -name '*.srt' ! -name '*.dat' | awk -F. '{print $NF}' | sort | uniq -c | sort -g >> /mnt/user/Media/media/MovieList_FileTypes.txt
echo "" >> /mnt/user/Media/media/MovieList_FileTypes.txt
echo "" >> /mnt/user/Media/media/MovieList_FileTypes.txt
echo "Total files: " >> /mnt/user/Media/media/MovieList_FileTypes.txt
find . -type f ! -name '*.srt' ! -name '*.dat' | wc -l >> /mnt/user/Media/media/MovieList_FileTypes.txt

# outputs file with movies title for each file type within Movies directory
find . -type f ! -name '*.srt' ! -name '*.dat' | cut -d/ -f 3- | sort -f > /mnt/user/Media/media/MovieList.txt
