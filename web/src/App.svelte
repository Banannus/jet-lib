<script lang="ts">
	import Dashboard from "$lib/Dashboard.svelte";
	import TextUI from "$lib/components/TextUI.svelte";
	import VisibilityProvider from "$lib/providers/VisibilityProvider.svelte";
	import TextUIVisibilityProvider from "$lib/providers/TextUIVisibilityProvider.svelte";
	import { createLocaleStore } from "$lib/stores/LocaleStore";

	createLocaleStore();
</script>

<!-- <VisibilityProvider>
	<Dashboard />
</VisibilityProvider> -->

<TextUIVisibilityProvider>
	<TextUI />
</TextUIVisibilityProvider>
