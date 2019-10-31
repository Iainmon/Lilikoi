module Lilikoi

    alias EntryList = Hash(String | UInt32, String)
    alias UInt32EntryList = Hash(UInt32, String)
    alias StringEntryList = Hash(String, String)

    alias Entry = NamedTuple(key: String | UInt32, value: String)
    alias UInt32Entry = NamedTuple(key: UInt32, value: String)
    alias StringEntry = NamedTuple(key: String, value: String)

end