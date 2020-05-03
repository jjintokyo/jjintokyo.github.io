#!/usr/bin/env python
# encoding=utf8
from __future__ import print_function
import re
import struct
import sys
import codecs
try:
    import urllib2
except ImportError:  # Python 3
    import urllib.request as urllib2
reload(sys)
sys.setdefaultencoding('utf8')
file = codecs.open("/home/pi/temp/url2", "w", "utf-8")
# url = 'http://pool.cdn.lagardere.cz/fm-evropa2-128'  # radio stream
url = sys.argv[1]
encoding = 'latin1' # default: iso-8859-1 for mp3 and utf-8 for ogg streams
# encoding = 'utf-8'
request = urllib2.Request(url, headers={'Icy-MetaData': 1})  # request metadata
response = urllib2.urlopen(request)
# print(response.headers, file=sys.stderr)
print(response.headers, file=sys.stdout)
metaint = int(response.headers['icy-metaint'])
for _ in range(10): # # title may be empty initially, try several times
    response.read(metaint)  # skip to metadata
    metadata_length = struct.unpack('B', response.read(1))[0] * 16  # length byte
    metadata = response.read(metadata_length).rstrip(b'\0')
    # print(metadata, file=sys.stderr)
    print(metadata, file=sys.stdout)
    # extract title from the metadata
    # m = re.search(br"StreamTitle='([^']*)';", metadata)
    start = "StreamTitle='"
    end = "';"
    try:
        title = re.search('%s(.*)%s' % (start, end), metadata).group(1)
        title = re.sub("StreamUrl='.*?';", "", title).replace("';", "").replace("StreamUrl='", "")
        title = re.sub("&artist=.*", "", title)
        title = re.sub("http://.*", "", title)
        title.rstrip()
    except Exception, err:
        title = ''
        # print("songtitle error: " + str(err))
        # title = content[metaint:].split("'")[1]
    # if m:
    # title = m.group(1)
    if title:
        break
else:
    file.write('no title found')
    file.write('\n\n')
    file.close()
    sys.exit(0)
title = title.decode(encoding, errors='replace')
title = title.encode('utf-8', 'ignore').decode('utf-8')
# title = title.encode('ascii', 'ignore').decode('ascii')
file.write(title)
file.write('\n\n')
file.close()
