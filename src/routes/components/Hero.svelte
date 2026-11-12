<script lang="ts">
	import { onMount } from "svelte";
	import FloatingLetter from "./FloatingLetter.svelte";
	import Nav from "./Nav.svelte";
	import { currentTheme } from "../themes.js";

	let firstName: string = "Harrison";
	let lastName: string = "DiAmbrosio";

	let vowels: string = "aeiou";

	let heroElement: HTMLElement;
	let firstLetterElements: HTMLSpanElement[] = [];
	let lastLetterElements: HTMLSpanElement[] = [];

	type LetterState = {
		element: HTMLSpanElement;
		baseX: number;
		baseY: number;
		x: number;
		y: number;
		rotation: number;
		velX: number;
		velY: number;
		velR: number;
	};

	const mouseRadius = 300;
	const targetRadius = 10;
	const friction = 0.05;
	const timeScale = 7;
	const motionScale = 4.2;
	const translationalOffset = 1500;
	const rotationalOffset = 720;

	onMount(() => {
		const elements = [...firstLetterElements, ...lastLetterElements];
		const states: LetterState[] = elements
			.filter((element): element is HTMLSpanElement => element != null)
			.map((element) => ({
				element,
				baseX: 0,
				baseY: 0,
				x: Math.floor(Math.random() * translationalOffset) - translationalOffset / 2,
				y: Math.floor(Math.random() * translationalOffset) - translationalOffset / 2,
				rotation: Math.floor(Math.random() * rotationalOffset) - rotationalOffset / 2,
				velX: 0,
				velY: 0,
				velR: 0,
			}));

		const pointer = { x: Number.NEGATIVE_INFINITY, y: Number.NEGATIVE_INFINITY };
		const motionQuery = window.matchMedia("(prefers-reduced-motion: reduce)");

		let frameId: number | null = null;
		let lastUpdate = 0;
		let isDesktop = window.innerWidth > 666;
		let isOnScreen = true;
		let reducedMotion = motionQuery.matches;
		let destroyed = false;

		const applyTransform = (state: LetterState) => {
			state.element.style.transform = `translate3d(${state.x}px, ${state.y}px, 0) rotate(${state.rotation}deg)`;
		};

		const measure = () => {
			const previousTransforms = states.map((state) => state.element.style.transform);

			for (const state of states) {
				state.element.style.transform = "none";
			}

			for (const state of states) {
				const rect = state.element.getBoundingClientRect();
				state.baseX = rect.left + window.scrollX + rect.width / 2;
				state.baseY = rect.top + window.scrollY + rect.height / 2;
			}

			for (let i = 0; i < states.length; i++) {
				states[i].element.style.transform = previousTransforms[i];
			}
		};

		const stop = () => {
			if (frameId !== null) {
				cancelAnimationFrame(frameId);
				frameId = null;
			}
		};

		const update = (now: number) => {
			if (lastUpdate === 0) lastUpdate = now;

			const deltaTime = (now - lastUpdate) / timeScale;
			lastUpdate = now;

			for (const state of states) {
				if (isDesktop && Number.isFinite(pointer.x)) {
					const centerX = state.baseX + state.x;
					const centerY = state.baseY + state.y;
					const deltaX = pointer.x - centerX;
					const deltaY = pointer.y - centerY;
					const mouseDistance = Math.hypot(deltaX, deltaY);

					if (mouseDistance < mouseRadius && mouseDistance > 0) {
						const repelX = -deltaX / mouseDistance;
						const repelY = -deltaY / mouseDistance;

						state.velX += repelX * deltaTime;
						state.velY += repelY * deltaTime;
						state.velR += repelX * deltaTime;
					}
				}

				const targetDistance = Math.hypot(state.x, state.y);

				if (targetDistance > targetRadius) {
					state.velX += (-state.x / (targetDistance + targetRadius)) * deltaTime;
					state.velY += (-state.y / (targetDistance + targetRadius)) * deltaTime;
					state.velR += (-state.rotation / (targetDistance + targetRadius)) * deltaTime;
				}

				state.velX += -state.velX * friction * deltaTime;
				state.velY += -state.velY * friction * deltaTime;
				state.velR += -state.velR * friction * deltaTime;

				state.x += state.velX * motionScale;
				state.y += state.velY * motionScale;
				state.rotation += state.velR * motionScale;

				applyTransform(state);
			}

			if (!reducedMotion && isOnScreen && !document.hidden) {
				frameId = requestAnimationFrame(update);
			} else {
				frameId = null;
			}
		};

		const start = () => {
			if (frameId !== null || reducedMotion || !isOnScreen || document.hidden) return;

			lastUpdate = 0;
			frameId = requestAnimationFrame(update);
		};

		const resetMotion = () => {
			stop();

			for (const state of states) {
				state.x = 0;
				state.y = 0;
				state.rotation = 0;
				state.velX = 0;
				state.velY = 0;
				state.velR = 0;
				applyTransform(state);
			}
		};

		const handleResize = () => {
			isDesktop = window.innerWidth > 666;
			measure();
		};

		const handlePointerMove = (event: PointerEvent) => {
			pointer.x = event.pageX;
			pointer.y = event.pageY;
		};

		const handleVisibilityChange = () => {
			if (document.hidden) {
				stop();
			} else {
				start();
			}
		};

		const handleMotionPreference = () => {
			reducedMotion = motionQuery.matches;

			if (reducedMotion) {
				resetMotion();
			} else {
				start();
			}
		};

		measure();

		if (reducedMotion) {
			resetMotion();
		} else {
			for (const state of states) {
				applyTransform(state);
			}
		}

		const observer = new IntersectionObserver((entries) => {
			isOnScreen = entries[0]?.isIntersecting ?? true;

			if (isOnScreen) {
				start();
			} else {
				stop();
			}
		});

		if (heroElement) {
			observer.observe(heroElement);
		}

		window.addEventListener("resize", handleResize);
		window.addEventListener("pointermove", handlePointerMove, { passive: true });
		document.addEventListener("visibilitychange", handleVisibilityChange);
		motionQuery.addEventListener("change", handleMotionPreference);

		start();

		document.fonts.ready.then(() => {
			if (!destroyed) {
				measure();
			}
		});

		return () => {
			destroyed = true;
			stop();
			observer.disconnect();
			window.removeEventListener("resize", handleResize);
			window.removeEventListener("pointermove", handlePointerMove);
			document.removeEventListener("visibilitychange", handleVisibilityChange);
			motionQuery.removeEventListener("change", handleMotionPreference);
		};
	});
</script>

<section bind:this={heroElement} class="hero">
	<h1 style="--foreground: {$currentTheme.foreground};">
		{#each firstName as l, i}
			<FloatingLetter letter={l} bind:element={firstLetterElements[i]} highlighted={vowels.includes(l.toLowerCase())}/>
		{/each}
		<br/>
		{#each lastName as l, i}
			<FloatingLetter letter={l} bind:element={lastLetterElements[i]} highlighted={vowels.includes(l.toLowerCase())}/>
		{/each}
	</h1>
	<Nav/>
</section>

<style>
	.hero {
		display: flex;
		align-items: center;
		min-width: 100mvw;
		min-height: 100vh;
		font-family: MonaspaceKr, monospace;
	}

	h1 {
		padding: 0px;
		font-size: 10vw;
		color: var(--foreground);
		flex-grow: 1;
	}

	@media (max-width: 1000px) and (min-width: 666px) {
		h1 {
			font-size: 10.25vw;
		}
	}

	@media (max-width: 666px) {
		.hero {
			flex-direction: column;
			justify-content: space-between;
		}

		h1 {
			writing-mode: vertical-rl;
			font-size: 12vh;
			line-height: 100%;
			text-align: left;
			flex-grow: 0;
		}
	}
</style>
