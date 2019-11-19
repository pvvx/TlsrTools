@rem Path=E:\Telink\NanosicSDK;E:\Telink\NanosicSDK\jre\bin;E:\Telink\NanosicSDK\opt\tc32\tools;E:\Telink\NanosicSDK\opt\tc32\bin;E:\Telink\NanosicSDK\usr\bin;E:\Telink\NanosicSDK\bin
@del /Q floader8269.bin
@del /Q floader8269.lst
make -s clean
make -s -j4