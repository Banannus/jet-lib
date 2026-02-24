<script lang="ts">
	import { onMount } from "svelte";
	import { textUIVisibilityStore as visibility } from "$lib/stores/TextUIVisibilityStore";
	import { textUIStore } from "$lib/stores/TextUI";
	import { useNuiEvent } from "$lib/hooks/useNuiEvent";
	import { fetchNui } from "$lib/utils/fetchNui";
	import { get } from "svelte/store";

	onMount(() => {
		const keyHandler = (e: KeyboardEvent) => {
			if ($visibility && e.code === "Escape") {
				fetchNui("hideUI");
				visibility.hide();
			}
		};

		window.addEventListener("keydown", keyHandler);
		return () => window.removeEventListener("keydown", keyHandler);
	});

	useNuiEvent("setVisibleText", (data: any) => {
		if (!data) {
			visibility.hide();
			return;
		}


		visibility.show();
		const defaults = get(textUIStore);
		textUIStore.set({ ...defaults, ...data });
	});
</script>

{#if $visibility}
	<slot />
{/if}
