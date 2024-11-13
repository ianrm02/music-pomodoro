#!/bin/zsh

# === Default values ===

MP3_FOLDER="$HOME/Projects/music-pomodoro/mp3"

PLAY_DURATION=${1:-25}
PAUSE_DURATION=${2:-5}
ROUNDS=${3:-4}

# === URLs ===

# TODO change this to read from a txt file
urls=(
    "https://www.youtube.com/watch?v=AQm5wxT7BGM&t=4s" # zelda wind waker
    "https://www.youtube.com/watch?v=kmR1v1gQtwA" # super mario galaxy
    "https://www.youtube.com/watch?v=Dg0IjOzopYU" # minecraft
    "https://www.youtube.com/watch?v=MXDF0wVcWfA" # zelda
    "https://www.youtube.com/watch?v=sA0qrPOMy2Y" # calm video game
    "https://www.youtube.com/watch?v=lr9LsULXgNA" # mario kart wii
    "https://www.youtube.com/watch?v=1wOAhRAqb40" # animal crossing rain
    "https://www.youtube.com/watch?v=DkDP6-yGN-M" # animal crossing calming
)

# === Functions ===

initialize_mp3_files() {
    if [[ ! -d "$MP3_FOLDER" ]]; then
        echo "Error: Directory '$MP3_FOLDER' does not exist."
        exit 1
    fi

    MP3_FILES=("$MP3_FOLDER"/*.mp3)

    if [[ ${#MP3_FILES[@]} -eq 0 ]]; then
        echo "Error: No MP3 files found in '$MP3_FOLDER'."
        exit 1
    fi
}

# TODO make mp3 be able to play through shorter times

play_mp3() {
    local file_to_play="$1"
    
    if [[ ! -r "$file_to_play" ]]; then
        echo "Error: Cannot read file '$file_to_play'. Skipping..."
        return 1
    fi

    mpg123 "$file_to_play" & PLAY_PID=$!
    echo "Playing '$file_to_play' [PID: $PLAY_PID]"
}

stop_mp3() {
    if [[ -n "$PLAY_PID" ]] && kill -0 "$PLAY_PID" 2>/dev/null; then
        kill "$PLAY_PID"
        echo "Stopped playing [PID: $PLAY_PID]"
    else
        echo "No active playback to stop."
    fi
}

# === Main ===

initialize_mp3_files

for ((i=1; i<=ROUNDS; i++)); do
    echo "----- Round $i -----"

    RANDOM_INDEX=$(( RANDOM % ${#MP3_FILES[@]} + 1 ))
    SELECTED_MP3="${MP3_FILES[$RANDOM_INDEX]}"

    play_mp3 "$SELECTED_MP3"

    # TODO add URL functionality

    # url=${urls[$(( (RANDOM % ${#urls[@]}) + 1 ))]}
    # yt-dlp -f bestaudio "$url" -o - 2>/dev/null | ffplay -nodisp -autoexit -t $play_seconds -i - &>/dev/null &

    sleep "$PLAY_DURATION"m

    stop_mp3

    echo "Pausing for $PAUSE_DURATION minutes..."
    sleep "$PAUSE_DURATION"m
done

echo "Script completed."