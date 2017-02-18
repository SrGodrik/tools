#!/bin/bash
#
# Pentest with UNIX grep tool...
# ----------------------------------------------------------------------------
# Simpel script for PenTesting.
#
  
  
if [ $# -ne 1 ]
then
  echo "Usage: `basename $0` directory-to-grep-through"
  exit 0
fi
###
#OPTIONS
###
ADDITIONAL_GREP_ARGUMENTS="-A 1 -B 3 --color=always"
TARGET="./grep-output"

DO_JAVA=true
DO_SPRING=true
DO_JSP=true
DO_ANDROID=true
DO_IOS=true
DO_PHP=true
DO_GENERAL=true

###
#END OPTIONS
###
  
GREP_ARGUMENTS="-nrP"
STANDARD_GREP_ARGUMENTS=$ADDITIONAL_GREP_ARGUMENTS" "$GREP_ARGUMENTS
SEARCH_FOLDER=$1
mkdir $TARGET
  
echo "Your standard grep arguments: $STANDARD_GREP_ARGUMENTS"
echo "Output will be put into this folder: $TARGET"
echo "You are currently greping through folder: $SEARCH_FOLDER"
sleep 2
  
#The Java stuff
if [ $DO_JAVA ]; then
    SEARCH_STRING='javax.crypto|bouncy.*?castle|new\sSecretKeySpec\(|messagedigest'
    OUTFILE="java_general_crypto.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
      
    SEARCH_STRING='toString\(\) *==|== *toString\(\)|" *==|== *"'
    OUTFILE="java_general_wrong_string_comparison.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

      
    SEARCH_STRING='\.exec\('
    OUTFILE="java_general_exec.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
      
    SEARCH_STRING='java\.net\.|java\.io\.|javax\.servlet|org\.apache\.http'
    OUTFILE="java_general_io.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
      
    SEARCH_STRING='@Entity|@ManyToOne|@OneToMany|@OneToOne|@Table|@Column'
    OUTFILE="java_persistent_beans.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep -l $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

      
    SEARCH_STRING='@Table\(|@Column\('
    OUTFILE="java_persistent_tables_and_columns_in_database.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

      
    SEARCH_STRING='string .{0,10}password|string .{0,10}secret|string .{0,10}key|string .{0,10}cvv|string .{0,10}user|string .{0,10}hash(?!(table|map|set|code))|string .{0,10}passcode|string .{0,10}passphrase|string .{0,10}user|string .{0,10}pin|string .{0,10}credit'
    OUTFILE="java_confidential_data_in_strings.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

fi
  

if [ $DO_SPRING ]; then
    SEARCH_STRING="DataBinder\.setAllowedFields"
    OUTFILE="java_spring_mass_assignment.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

fi
  

if [ $DO_JSP ]; then
    SEARCH_STRING="escape\s*=\s*\"?\s*false|escape\s*=\s*\'?\s*false"
    OUTFILE="java_jsp_xss.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

      
    SEARCH_STRING="<s:file "
    OUTFILE="java_jsp_file_upload.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
fi
  

if [ $DO_ANDROID ]; then
  
    SEARCH_STRING='\.printStackTrace\(|Log\.(e|w|i|d|v)\('
    OUTFILE="android_logging.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

      
    SEARCH_STRING='MODE_|\.openFile\(|\.openOrCreate|\.getDatabase\(|\.openDatabase\(|\.getShared|\.getCache|\.getExternalCache|query\(|rawQuery\(|compileStatement\('
    OUTFILE="android_access.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

      
    SEARCH_STRING='<intent-filter>|\.getIntent\(\)\.getData\(\)|RunningAppProcessInfo'
    OUTFILE="android_intents.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
      
fi
  

  
if [ $DO_IOS ]; then
    SEARCH_STRING='NSFileProtection|NSFileManager|NSPersistantStoreCoordinator|NSData' 
    OUTFILE="ios_file_access.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

  
    SEARCH_STRING='kSecAttrAccessible|SecItemAdd|KeychainItemWrapper|Security\.h'
    OUTFILE="ios_keychain.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

  
    SEARCH_STRING='CFBundleURLSchemes|kCFStream|CFFTPStream|CFHTTP|CFNetServices|FTPURL|IOBluetooth'
    OUTFILE="ios_network.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

  
    SEARCH_STRING='NSLog\('
    OUTFILE="ios_logging.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
  
    SEARCH_STRING='initWithFormat:|informativeTextWithFormat:|format:|stringWithFormat:|appendFormat:|predicateWithFormat:|NSRunAlertPanel'
    OUTFILE="ios_string_format_functions.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

  
    SEARCH_STRING='handleOpenURL:|openURL:'
    OUTFILE="ios_url_handler.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
fi
 

 
if [ $DO_PHP ]; then
    SEARCH_STRING='\$_GET|\$_POST'
    OUTFILE="php_get_post.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
     
    SEARCH_STRING='crypt\('
    OUTFILE="php_crypt_call.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
fi
 

  
if [ $DO_GENERAL ]; then
    SEARCH_STRING='\b[A-Za-z0-9._%+\-]+@[A-Za-z0-9.\-]+\.[A-Za-z]{2,4}\b'
    OUTFILE="email.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

     
    SEARCH_STRING='todo|workaround'
    OUTFILE="todo_workaround.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
  
    SEARCH_STRING='hack|crack|exploit|bypass|backdoor|backd00r'
    OUTFILE="exploit.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" | grep -vE 'Ack|setCdrBackdoor' | grep -viE 'imageshack' > $TARGET/$OUTFILE
  
    SEARCH_STRING='https?://'
    OUTFILE="https_and_http_urls.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

  
    SEARCH_STRING='http://|ftp://|imap://|file://'
    OUTFILE="no_ssl_uris.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

  
    SEARCH_STRING='malloc\(|realloc\('
    OUTFILE="initialisation.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE

  
    SEARCH_STRING='memcpy\(|memset\(|strcat\(|strcpy\(|strncat\(|strncpy\(|sprintf\(|gets\('
    OUTFILE="insecure_c_functions.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"

    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
    
    SEARCH_STRING='default.?password|passwo?r?d|passcode|hash.?(?!(table|map|set|code))|pass.?phrase|salt|encryption.?key|encrypt.?key|BEGIN CERTIFICATE---|PRIVATE KEY---|Proxy-Authorization|pin'
    OUTFILE="keys.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
  
    SEARCH_STRING='root.*?detection|rooted.*?Device|is.*?rooted|detect.*?root|jail.*?break'
    OUTFILE="root.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
  
    SEARCH_STRING='sql.{0,10}injection|xss|click.{0,10}jacking|xsrf|directory.{0,10}listing|buffer.{0,10}overflow|obfuscate'
    OUTFILE="hacking_techniques.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
    
  
    SEARCH_STRING='`.{2,100}`'
    OUTFILE="backticks.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    
    grep -I $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
    
    SEARCH_STRING='location\.hash|location\.href|location\.pathname|location\.search|eval\(|\.appendChild\(|document\.write\(|document\.writeln\(|\.innerHTML\s*?=|\.outerHTML\s*?='
    OUTFILE="dom_xss.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    
    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
  
    SEARCH_STRING='SELECT.*?FROM|INSERT.*?INTO|DELETE.*?WHERE|sqlite'
    OUTFILE="sql.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
  
    SEARCH_STRING='^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{4})$'
    OUTFILE="base64.txt"
    
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
    
  
    SEARCH_STRING='GNU\sGPL|GPLv2|GPLv3|GPL\sVersion|General\sPublic\sLicense'
    OUTFILE="gpl.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
    
  
    SEARCH_STRING='stupid|fuck|shit|crap'
    OUTFILE="swear.txt"
    echo "Searching for $SEARCH_STRING --> writing to $OUTFILE"
    grep -i $STANDARD_GREP_ARGUMENTS "$SEARCH_STRING" "$SEARCH_FOLDER" > $TARGET/$OUTFILE
fi
  
echo "Done grep. Results in $TARGET."
