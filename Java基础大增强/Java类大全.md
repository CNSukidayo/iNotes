### java.base
1. [x] JDK9模块
2. [x] java.math
   1. [x] BigDecimal
   2. [x] MathContext
   3. [x] RoundingMode 
   4. [x] BigInteger
3. [x] java.text
   1. [x] Format 
   2. [x] NumberFormat
   3. [x] DecimalFormat
   4. [x] ChoiceFormat
   5. [x] DateFormat
   6. [x] SimpleDateFormat
   7. [x] MessageFormat
   8. [x] CharacterIterator
   9. [x] AttributedCharacterIterator
   10. [x] AttributedString
4.  [x] java.time
    1.  [x] DateTimeFormatterBuilder
    2.  [x] Clock
    3.  [x] DateTimeException
    4.  [x] DayOfWeek
    5.  [x] Duration
    6.  [x] Instant
    7.  [x] LocalDate
    8.  [x] LocalDateTime
    9.  [x] LocalTime
    10. [x] Month
    11. [x] MonthDay
    12. [x] OffsetDateTime
    13. [x] Period
    14. [x] Year
    15. [x] YearMonth
    16. [x] ZonedDateTime
    17. [x] ZoneId
    18. [x] ZoneOffset
5. [x] java.io
   1. [x] Closeable 
   2. [x] File
   3. [x] Flushable
   4. [x] FileFilter
   5. [x] FilenameFilter
   6. [x] InputStream
   7. [x] OutputStream
   8. [x] FileInputStream
   9. [x] FileOutputStream
   10. [x] FileDescriptor 
   11. [x] FileNotFoundException 
   12. [x] StandardCharsets
   13. [x] Reader
   14. [x] FileReader
   15. [x] InputStreamReader
   16. [x] StreamDecoder
   17. [x] Writer
   18. [x] FileWriter
   19. [x] OutputStreamWriter
   20. [x] StreamEncoder
   21. [x] ByteArrayOutputStream
   22. [x] ByteArrayInputStream
   23. [x] BufferedInputStream
   24. [x] BufferedOutputStream
   25. [x] BufferedReader
   26. [x] BufferedWriter
   27. [x] FilterOutputStream
   28. [x] FilterInputStream
   29. [x] DataInput
   30. [x] DataOutput
   31. [x] ObjectInput
   32. [x] ObjectOutput
   33. [x] DataInPutStream
   34. [x] DataOutPutStream
   35. [x] ObjectStreamClass
   36. [x] ObjectOutputStream
   37. [x] ObjectInputStream `这两个类不需要细究了`
   38. [x] PrintStream
   39. [x] PrintWriter `注意它们两个的区别`
   40. [x] UnsupportedEncodingException
   41. [x] EOFException
   42. [x] RandomAccessFile
   43. [x] CharArrayReader
   44. [x] CharArrayWriter
   45. [x] Console
   46. [x] InterruptedIOException
   47. [x] IOException
   48. [x] InvalidObjectException
   49. [x] IOError
   50. [x] CharConversionException 
   51. [x] LineNumberReader
   52. [x] NotActiveException
   53. [x] ObjectStreamException
   54. [x] NotSerializableException
   55. [x] PushbackInputStream
   56. [x] PushbackReader
   57. [x] SequenceInputStream
   58. [x] StringReader
   59. [x] StringWriter
6. [ ] java.lang
   1. [x] NumberFormatException
   2. [x] Cleaner 
   3. [x] AutoCloseable
   4. [x] StringBuilder
   5. [x] StringBuffer `注意它们两个的区别`
   6. [x] Properties
   7. [ ] Enum
7. [ ] java.net
   1. [x] SocketAddress
   2. [x] InetSocketAddress
   3. [x] InetAddress
   4. [x] Inet6Address
   5. [x] Inet4Address
   6. [x] URI
   7. [x] URL
   8. [x] SocketOption
   9.  [x] ContentHandlerFactory
   10. [x] ContentHandler
   11. [x] CookieHandler
   12. [x] CookieManager
   13. [x] CookieStore
   14. [x] CookiePolicy
   15. [x] DatagramSocket
   16. [x] DatagramPacket
   17. [x] DatagramSocketImplFactory
   18. [x] DatagramSocketImpl
   19. [x] FileNameMap
   20. [x] HttpCookie
   21. [x] URLConnection
   22. [x] JarURLConnection
   23. [x] PasswordAuthentication
   24. [x] ProtocolFamily
   25. [x] StandardProtocolFamily
   26. [x] MulticastSocket
   27. [x] NetworkInterface
   28. [x] Proxy
   29. [x] ProxySelector
   30. [x] ServerSocket
   31. [x] Socket
   33. [x] SocketImplFactory
   34. [x] SocketImpl
   35. [x] StandardSocketOptions
   36. [x] URI
   37. [x] URL
   38. [x] URLDecoder
   39. [x] URLEncoder
   40. [x] URLStreamHandler
   41. [x] URLStreamHandlerFactory
8. [x] java.nio
   1. [x] ByteBuffer
   2. [x] SeekableByteChannel
   3. [x] CharBuffer
   4. [x] ShrotBuffert
   5. [x] IntBuffer
   6. [x] LongBuffer
   7. [x] FloatBuffer
   8. [x] DoubleBuffer 
   9. [x] AccessMode
   10. [x] OpenOption
   11. [x] CopyOption
   12. [x] StandardOpenOption
   13. [x] StandardCopyOption
   14. [x] LinkOption
   15. [x] AccessMode
   16. [x] Paths
   17. [x] Watchable
   18. [x] WatchEvent
   19. [x] WatchEvent.Kind
   20. [x] WatchEvent.Modifier
   21. [x] WatchKey
   22. [x] Path
   23. [x] WatchService
   24. [x] FileSystem
   25. [x] ClosedWatchServiceException
   26. [x] StandardWatchEventKinds
   27. [x] DirectoryStream
   28. [x] DirectoryStream.Filter
   29. [x] Files
   30. [x] File
   31. [x] FileSystems
   32. [x] FileStore
   33. [x] FileVisitOption
   34. [x] FileVisitor
   35. [x] BasicFileAttributes
   36. [x] FileTime
   37. [x] FileVisitor
   38. [x] FileVisitResult
   39. [x] PathMatcher
   40. [x] StandardCharsets
   41. [x] Charset
   42. [x] CoderResult
   43. [x] Channel
   44. [x] InterruptibleChannel
   45. [x] AsynchronousCloseException 
   46. [x] ClosedByInterruptException 
   47. [x] AbstractInterruptibleChannel
   48. [x] FileChannel
   49. [x] Channels
   50. [x] MappedByteBuffer
   51. [x] FileLock
   52. [x] ScatteringByteChannel
   53. [x] GatheringByteChannel
   54. [x] NetworkChannel
   55. [x] SelectableChannel
   56. [x] AbstractSelectableChannel
   57. [x] ServerSocketChannel
   58. [x] SocketChannel
   59. [x] Selector
   60. [x] SelectorProvider
   61. [x] SelectionKey
   62. [x] DatagramChannel
   63. [x] MulticastChannel
   64. [x] Pipe
   65. [x] AsynchronousChannel
   66. [x] AsynchronousFileChannel
   67. [x] AsynchronousByteChannel
   68. [x] AsynchronousChannelGroup
   69. [x] CompletionHandler
   70. [x] AsynchronousSocketChannel
   71. [x] AsynchronousServerSocketChannel
9. [ ] java.util
   1.  [x] Iterable
   2.  [ ] ListIterator
   3.  [ ] Collection
   4.  [ ] AbstractCollection
   5.  [ ] List
   6.  [ ] AbstractList
   7.  [ ] AbstractSequentialList
   8.  [ ] Queue
   9.  [ ] AbstractQueue
   10. [ ] LinkedList
   11. [ ] Deque
   12. [ ] Map
   13. [ ] AbstractMap
   14. [ ] IdentityHashMap
   15. [ ] HashMap
   16. [ ] LinkedHashMap
   17. [ ] LinkedHashSet
   18. [ ] SortedMap
   19. [ ] NavigableMap
   20. [ ] TreeMap
   21. [ ] WeakHashMap
   22. [x] Dictionary 
   23. [ ] Hashtable `注意Hashtable和HashMap的区别`
   24. [ ] Set
   25. [ ] SortedSet
   26. [ ] NavigableSet
   27. [ ] AbstractSet
   28. [ ] HashSet
   29. [ ] TreeSet
   30. [ ] ArrayDeque
   31. [ ] ArrayList
   32. [ ] Vector
   33. [ ] Stack
   34. [ ] Arrays
   35. [ ] Base64
   36. [x] BitSet
   37. [ ] Calendar
   38. [ ] GregorianCalendar
   38. [ ] Collections
   39. [ ] Comparator
   40. [x] Currency
   41. [x] Date
   42. [ ] DoubleSummaryStatistics
   43. [ ] IntSummaryStatistics
   44. [ ] LongSummaryStatistics
   45. [ ] java.util.stream.Collectors
   46. [ ] Enumeration
   47. [ ] EnumMap
   48. [ ] EnumSet
   49. [ ] EventListener
   50. [x] EventListenerProxy
   51. [ ] EventObject
   52. [ ] Formattable
   53. [ ] FormattableFlags
   54. [ ] Formatter 
   55. [x] HexFormat
   56. [ ] ResourceBundle
   57. [ ] ListResourceBundle
   58. [ ] Locale
   59. [ ] Objects
   60. [ ] Optional
   61. [ ] OptionalDouble
   62. [ ] OptionalInt
   63. [ ] OptionalLong
   64. [ ] PrimitiveIterator
   65. [ ] PriorityQueue
   66. [ ] PropertyResourceBundle
   67. [ ] Random
   68. [ ] RandomAccess
   69. [ ] ResourceBundle
   70. [x] Scanner
   71. [ ] ServiceLoader
   72. [x] SimpleTimeZone
   73. [ ] Spliterator
   74. [ ] Spliterators
   75. [x] SplittableRandom
   76. [x] StringJoiner
   77. [x] Timer
   78. [x] TimerTask
   79. [x] TimeZone
   80. [x] UUID
       1.  [x] function
           1.  [x] DoubleConsumer 
           2.  [ ] IntConsumer
           3.  [ ] LongConsumer
       2. [ ] concurrent
       3. [x] random
          1. [x] RandomGenerator
          2. [x] RandomGeneratorFactory
       4. [x] regex
          1. [x] Matcher
          2. [x] Pattern
          3. [x] MatchResult 
       5. [ ] zip
       6. [ ] jar