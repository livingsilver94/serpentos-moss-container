/* SPDX-License-Identifier: Zlib */

/**
 * Fakeroot discovery
 *
 * Basic discovery of the `fakeroot` binary to ensure we always
 * prefer the `fakeroot-sysv` variant over the `fakeroot-tcp`
 * variant which is painfully slow on Linux.
 *
 * Notes: We intend to replace fakeroot usage in future with
 * our own library.
 *
 * Authors: © 2020-2022 Serpent OS Developers
 * License: ZLib
 */
module moss.container.fakeroot;

import moss.container.context;
import std.file : exists;
import std.path : buildPath;

/**
 * Known locations for the fakeroot executable.
 * Special care is taken to avoid `fakeroot-tcp`
 * as it is unacceptably slow on Linux
 */
public enum FakerootBinary : string
{
    None = null,
    Sysv = "/usr/bin/fakeroot-sysv",
    Default = "/usr/bin/fakeroot"
}

/**
 * Determine the availability of fakeroot
 */
package FakerootBinary discoverFakeroot()
{
    auto locations = [FakerootBinary.Sysv, FakerootBinary.Default,];

    /* Iterate sane locations of fakeroot */
    foreach (searchLocation; locations)
    {
        auto fullPath = context.rootfs.buildPath((cast(string) searchLocation)[1 .. $]);
        if (fullPath.exists)
        {
            return searchLocation;
        }
    }

    return FakerootBinary.None;
}
