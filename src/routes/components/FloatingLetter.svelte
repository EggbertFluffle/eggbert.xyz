<script lang="ts">
	import { currentTheme } from "../themes.js";

	export let letter: string;
	export let highlighted: boolean;
	export let element: HTMLSpanElement;
</script>

<span bind:this={element} style:color={highlighted ? $currentTheme.red : "inherit"}>{letter}</span>

<style>
	span {
		font-size: inherit;
		font-family: MonaspaceKR, monospace;
		display: inline-block;
		user-select: none;
		will-change: transform;
	}
</style>
