
import std.stdio;
import std.getopt;
import std.algorithm;
import std.regex;

import std.net.browser;

int main(string[] args)
{
    if (args.length < 2)
    {
        writeln("dman: Look up D topics in the manual
Usage:
    dman [-man] topic
");
        return 1;
    }

    bool man;
    getopt(args, "man", { man = true; });

    if (man)
        browse("http://www.digitalmars.com/");
    else if (args.length != 2)
    {
        writeln("dman: no topic");
        return 1;
    }

    auto topic = args[1];

    auto url = topic2url(topic);
    if (url)
    {
        browse(url);
    }
    else
    {
        writefln("dman: topic '%s' not found", topic);
        return 1;
    }

    return 0;
}

string topic2url(string topic)
{
    /* Instead of hardwiring these, dman should read from a .json database pointed to
     * by sc.ini or dmd.conf.
     */

    string url;

    url = DmcCommands(topic);
    if (!url)
        url = Misc(topic);
    if (!url)
        url = Phobos(topic);
    return url;
}

string DmcCommands(string topic)
{
    static string[] dmccmds =
    [ "bcc", "chmod", "cl", "coff2omf", "coffimplib", "dmc", "diff", "diffdir",
      "dump", "dumpobj", "dumpexe", "exe2bin", "flpyimg", "grep", "hc", "htod",
      "implib", "lib", "libunres", "link", "linker", "make", "makedep",
      "me", "obj2asm", "optlink", "patchobj",
      "rc", "rcc", "sc", "shell", "smake", "touch", "unmangle", "whereis",
    ];

    if (find(dmccmds, topic).length)
    {
        if (topic == "dmc")
            topic = "sc";
        else if (topic == "link")
            topic = "optlink";
        else if (topic == "linker")
            topic = "optlink";
        return "http://www.digitalmars.com/ctg/" ~ topic ~ ".html";
    }
    return null;
}

string Misc(string topic)
{
    string[string] misc =
    [
        "D1": "http://www.digitalmars.com/d/1.0/",
        "faq": "http://d-programming-language.org/faq.html",
    ];

    auto purl = topic in misc;
    if (purl)
        return *purl;
    return null;
}

string Phobos(string topic)
{
    string phobos = "http://www.d-programming-language.org/phobos/";
    if (find(topic, '.'))
    {
        topic = replace(topic, regex("\\.", "g"), "_");
        return phobos ~ topic ~ ".html";
    }
    return null;
}