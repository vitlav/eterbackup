#!/bin/sh

BASEDIR=/tmp/eterbackup-TD
ETERPACK=$(pwd)/../bin/eterpack

rm -rf $BASEDIR

. ./eterbackup-functions.sh

create_tree $BASEDIR/sample

cd $BASEDIR || exit 1

sh -x $ETERPACK update --depth 2 --exclude stage2 sample packed || fatal "update failed"

$ETERPACK extract packed unpacked || fatal "extract failed"

[ -d unpacked/stage1 ] || fatal "missed stage1 dir"

[ -d unpacked/stage1/stage2 ] && fatal "excluded stage1/stage2 dir is exists"

$ETERPACK check packed || fatal "check failed"

cp -al sample sample-mod
rm -rf sample-mod/stage1/stage2

$ETERPACK compare packed sample-mod || fatal "comparison is failed"
$ETERPACK compare --checksum packed sample-mod || fatal "comparison with checksum is failed"

diff_dirs unpacked sample-mod

diffls_dirs unpacked sample-mod


echo "Done! OK!"
echo "Please, check and remove $BASEDIR"
#rm -rf $BASEDIR
