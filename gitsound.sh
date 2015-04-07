#!/bin/bash

#echo "Config..."
TEMPLATE="${HOME}/.git_template"
SOUNDS="${HOME}/.git_sounds"
CONFIG=`git config --global init.templatedir`
HOOKS=( "applypatch-msg" "pre-applypatch" "post-applypatch" "pre-commit" "prepare-commit-msg" "commit-msg" "post-commit" "pre-rebase" "post-checkout" "post-merge" "pre-push" "pre-receive" "update" "post-receive" "post-update" "pre-auto-gc" "post-rewrite" "rebase" )
PLAYERS=( "afplay" "aplay" "mplayer" "ffplay" "cvlc" "nvlc" "mocp" "play" )
DOWNLOADERS=( "curl -o" "wget -O" )

#echo "Searching for git package..."
git --version > /dev/null 2>&1
if [[ $? -ne 0 ]]; then
	echo "Git package not found on this system."
	exit 100
fi

#echo "Searching for media player..."
PLAYER=""
PLAYERCMD=""
for ITEM in "${PLAYERS[@]}"; do
	ARR=($ITEM)
	CMD=${ARR[0]}
	PRM=${ARR[@]:1}

	if [ "$PLAYER" == "" ] && `which ${CMD} >/dev/null`; then
		PLAYER=`which ${CMD}`
		PLAYERCMD="${PLAYER} ${PRM} "
	fi
done
if ! which $PLAYER >/dev/null; then
	echo "Unable do determine media player."
    exit 200
fi

#echo "Searching for downloader..."
DOWNLOADER=""
DOWNLOADERCMD=""
for ITEM in "${DOWNLOADERS[@]}"; do
	ARR=($ITEM)
	CMD=${ARR[0]}
	PRM=${ARR[@]:1}

	if [ "$DOWNLOADER" == "" ] && `which ${CMD} >/dev/null`; then
		DOWNLOADER="`which ${CMD}`"
		DOWNLOADERCMD="${DOWNLOADER} ${PRM} "
	fi
done
if ! which $DOWNLOADER >/dev/null; then
	echo "Unable do determine downloader."
    exit 300
fi

echo "This action will create git template directory and change global init.templatedir configuration."
if [[ $CONFIG != $TEMPLATE ]]; then
	echo -e "You can revert old config by executing: \e[93mgit config --global init.templatedir ${CONFIG}\e[0m"
fi
while true; do
	read -p "Do you wish to continue [y/n]? " yn
	case $yn in
		[Yy]* ) break;;
		[Nn]* ) echo "Canceling..."; exit;;
		* ) echo "Please answer yes or no.";;
	esac
done

echo "Creating git template directory..."
mkdir -p ${TEMPLATE}/hooks
git config --global init.templatedir ${TEMPLATE}

echo "Creating git hooks..."
for HOOK in "${HOOKS[@]}"; do
	echo "#!/bin/sh" > ${TEMPLATE}/hooks/${HOOK}
	echo "" >> ${TEMPLATE}/hooks/${HOOK}
	echo "if [ -f ${SOUNDS}/${HOOK}.wav ]; then" >> ${TEMPLATE}/hooks/${HOOK}
	echo -e "\t$PLAYER ${SOUNDS}/${HOOK}.wav </dev/null >/dev/null 2>&1 &" >> ${TEMPLATE}/hooks/${HOOK}
	echo "fi" >> ${TEMPLATE}/hooks/$HOOK
	chmod 755 ${TEMPLATE}/hooks/$HOOK
done

echo "Creating git sound directory..."
mkdir -p ${SOUNDS}
echo "Add wav file for each git hook:" > ${SOUNDS}/README
for HOOK in "${HOOKS[@]}"; do
	echo -e "\t${HOOK}.wav" >> ${SOUNDS}/README
done
chmod 644 ${SOUNDS}/README

echo "Downloading sounds..."
$DOWNLOADERCMD ${SOUNDS}/post-commit.wav http://themushroomkingdom.net/sounds/wav/smw/smw_egg_hatching.wav &> /dev/null
chmod 644 ${SOUNDS}/post-commit.wav
$DOWNLOADERCMD ${SOUNDS}/post-checkout.wav http://themushroomkingdom.net/sounds/wav/smw/smw_1-up.wav &> /dev/null
chmod 644 ${SOUNDS}/post-checkout.wav
$DOWNLOADERCMD ${SOUNDS}/post-merge.wav http://themushroomkingdom.net/sounds/wav/smw/smw_power-up.wav &> /dev/null
chmod 644 ${SOUNDS}/post-merge.wav
$DOWNLOADERCMD ${SOUNDS}/pre-push.wav http://themushroomkingdom.net/sounds/wav/smw/smw_power-up_appears.wav &> /dev/null
chmod 644 ${SOUNDS}/pre-push.wav

echo "Done."
