// SPDX-License-Identifier: GPL-3.0-only
pragma solidity 0.8.21;

struct AddressSet {
    address[] addrs;
    mapping(address => bool) saved;
    mapping(address => uint256) addrsIndex;
}

library LibAddressSet {
    function add(AddressSet storage s, address addr) internal {
        if (!s.saved[addr]) {
            s.addrsIndex[addr] = s.addrs.length;
            s.addrs.push(addr);
            s.saved[addr] = true;
        }
    }

    function remove(AddressSet storage s, address addr) internal {
        if (s.saved[addr]) {
            address lastAddrs = s.addrs[s.addrs.length - 1];

            if (addr != lastAddrs) {
                s.addrs[s.addrsIndex[addr]] = lastAddrs;
                s.addrsIndex[lastAddrs] = s.addrsIndex[addr];
            }

            s.addrs.pop();
            s.saved[addr] = false;
            delete s.addrsIndex[addr];
        }
    }

    function contains(AddressSet storage s, address addr) internal view returns (bool) {
        return s.saved[addr];
    }

    function count(AddressSet storage s) internal view returns (uint256) {
        return s.addrs.length;
    }

    function rand(AddressSet storage s, uint8 seed) internal view returns (address) {
        if (s.addrs.length > 0) {
            return s.addrs[seed % s.addrs.length];
        } else {
            return address(0);
        }
    }

    function forEach(AddressSet storage s, function(address) external func) internal {
        for (uint256 i; i < s.addrs.length; ++i) {
            func(s.addrs[i]);
        }
    }

    function reduce(
        AddressSet storage s,
        uint256 acc,
        function(uint256,address) external returns (uint256) func
    ) internal returns (uint256) {
        for (uint256 i; i < s.addrs.length; ++i) {
            acc = func(acc, s.addrs[i]);
        }
        return acc;
    }

    function length(AddressSet storage s) internal view returns (uint256) {
        return s.addrs.length;
    }
}