// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DailyCheckIn} from "../src/DailyCheckIn.sol";

contract DailyCheckInTest is Test {
    DailyCheckIn public checkIn;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        checkIn = new DailyCheckIn(100);
    }

    function test_Constructor() public {
        assertEq(checkIn.owner(), address(this));
        assertEq(checkIn.maxParticipants(), 100);
    }

    function test_CheckIn() public {
        checkIn.checkIn();
        assertTrue(checkIn.hasCheckedInToday(address(this)));
        assertEq(checkIn.getTodayCount(), 1);
        assertEq(checkIn.getTotalCheckIns(address(this)), 1);
    }

    function test_CannotCheckInTwiceSameDay() public {
        checkIn.checkIn();
        vm.expectRevert("Already checked in today");
        checkIn.checkIn();
    }

    function test_MultipleUsersCheckIn() public {
        vm.prank(alice);
        checkIn.checkIn();

        vm.prank(bob);
        checkIn.checkIn();

        assertEq(checkIn.getTodayCount(), 2);
        assertTrue(checkIn.hasCheckedInToday(alice));
        assertTrue(checkIn.hasCheckedInToday(bob));
    }

    function test_MaxParticipantsReached() public {
        DailyCheckIn small = new DailyCheckIn(2);

        small.checkIn();

        vm.prank(alice);
        small.checkIn();

        // 第三个人来 — 满了
        vm.prank(bob);
        vm.expectRevert("Today's quota reached");
        small.checkIn();
    }

    function test_NewDayResets() public {
        checkIn.checkIn();
        assertEq(checkIn.getTodayCount(), 1);

        // 跳到第二天
        vm.warp(block.timestamp + 1 days + 1);

        vm.prank(alice);
        checkIn.checkIn();

        assertEq(checkIn.getTodayCount(), 1);  // 重置了，alice 是第一个
        assertTrue(checkIn.hasCheckedInToday(alice));
        assertFalse(checkIn.hasCheckedInToday(address(this)));  // 昨天的已经失效
    }

    function test_Records() public {
        uint256 ts1 = block.timestamp;
        checkIn.checkIn();

        vm.warp(block.timestamp + 2 days);
        uint256 ts2 = block.timestamp;
        checkIn.checkIn();

        DailyCheckIn.Record[] memory records = checkIn.getRecords(address(this));
        assertEq(records.length, 2);
        assertEq(records[0].timestamp, ts1);
        assertEq(records[1].timestamp, ts2);
        assertEq(checkIn.getTotalCheckIns(address(this)), 2);
    }

    function test_SetMaxParticipants() public {
        checkIn.setMaxParticipants(50);
        assertEq(checkIn.maxParticipants(), 50);
    }

    function test_OnlyOwnerCanSetMax() public {
        vm.prank(alice);
        vm.expectRevert("Not owner");
        checkIn.setMaxParticipants(50);
    }
}
