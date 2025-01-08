// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {JoesSwapV1} from "../src/JoesSwapV1.sol";

contract JoesSwapV1Test is Test {
    JoesSwapV1 joesSwap1;
    address token0;
    address token1;

    function setUp() public {
        joesSwap1 = new JoesSwapV1(token0, token1);
    }

    function test_addLiquidity() public {
        uint256 amount0 = 500;
        uint256 amount1 = 100;

        joesSwap1.addLiquidity(amount0, amount1);

        assertEq(joesSwap1.reserve0(), amount0);
        assertEq(joesSwap1.reserve1(), amount1);
        assertEq(joesSwap1.liquidity(), sqrt(amount0 * amount1));
    }

    function test_removeLiquidity() public {
        joesSwap1.addLiquidity(1000, 100);
        joesSwap1.removeLiquidity(100);

        assertEq(joesSwap1.liquidity(), 216);
        assertEq(joesSwap1.reserve0(), 684);
        assertEq(joesSwap1.reserve1(), 69);
    }

    function test_removeLiquidity2() public {
        joesSwap1.addLiquidity(1000, 100);
        joesSwap1.removeLiquidity(316);

        assertEq(joesSwap1.liquidity(), 0);
        assertEq(joesSwap1.reserve0(), 0);
        assertEq(joesSwap1.reserve1(), 0);
    }

    function test_swap() public {
        joesSwap1.addLiquidity(1000, 100);

        uint256 swapAmount = 100;
        uint256 liquidityBefore = joesSwap1.liquidity();
        uint256 reserve0Before = joesSwap1.reserve0();
        uint256 reserve1Before = joesSwap1.reserve1();

        joesSwap1.swap(100);

        uint256 reserve1AfterExpected = (reserve0Before * reserve1Before) /
            (reserve0Before + swapAmount);

        assertEq(joesSwap1.liquidity(), liquidityBefore);
        assertEq(joesSwap1.reserve0(), reserve0Before + swapAmount);
        assertEq(joesSwap1.reserve1(), reserve1AfterExpected);
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        y = x;
        uint256 z = (x + 1) / 2;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}
