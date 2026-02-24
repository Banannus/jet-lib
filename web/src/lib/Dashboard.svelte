<script lang="ts">
	import { fetchNui } from "$lib/utils/fetchNui";
	import { visibilityStore as visibility } from "$lib/stores/VisibilityStore";
	import { getLocale } from "$lib/utils/locale";
	import { localesStore } from "$lib/stores/LocalesStore";

	interface ReturnData {
		x: number;
		y: number;
		z: number;
	}

	let players = 0;
	let serverTime = new Date().toLocaleTimeString();
	let clientData: ReturnData | null = null;

	setInterval(() => {
		serverTime = new Date().toLocaleTimeString();
	}, 1000);

	const handleClientData = () => {
		fetchNui("getClientData")
			.then((returnData) => {
				clientData = returnData;
			})
			.catch(() => {
				clientData = { x: 100, y: 100, z: 100 };
			});
	};

	const closeDialog = () => {
		visibility.toggle(false);
		fetchNui("hideUI");
	};

	const resetCoords = () => {
		clientData = null;
	};

	// Translation helper
	const t = (key: string, defaultValue: string = key) => getLocale($localesStore, key, defaultValue);

</script>

<div class="flex items-center justify-center min-h-screen w-full p-4">
	<div class="flex flex-col w-full max-w-md bg-slate-800 rounded-lg shadow-2xl border border-slate-700">
		<!-- Header -->
		<div class="bg-gradient-to-r from-blue-600 to-blue-700 px-6 py-4 rounded-t-lg">
			<h1 class="text-xl sm:text-2xl font-bold text-white">{t("ui.dashboard.title", "Status Panel")}</h1>
		</div>

		<!-- Content -->
		<div class="p-4 sm:p-6 space-y-3 sm:space-y-4">
			<!-- Status Row -->
			<div class="flex justify-between items-center">
				<span class="text-slate-300 font-medium text-sm sm:text-base">{t("ui.dashboard.status", "Server Status")}</span>
				<div class="flex items-center gap-2">
					<div class="w-2 h-2 sm:w-3 sm:h-3 bg-green-500 rounded-full animate-pulse"></div>
					<span class="text-green-400 font-semibold text-sm sm:text-base">{t("ui.dashboard.online", "Online")}</span>
				</div>
			</div>

			<!-- Players Row -->
			<div class="flex justify-between items-center">
				<span class="text-slate-300 font-medium text-sm sm:text-base">{t("ui.dashboard.players", "Players Online")}</span>
				<span class="text-blue-400 font-semibold text-base sm:text-lg">{players}/32</span>
			</div>

			<!-- Time Row -->
			<div class="flex justify-between items-center">
				<span class="text-slate-300 font-medium text-sm sm:text-base">{t("ui.dashboard.time", "Server Time")}</span>
				<span class="text-amber-400 font-mono text-xs sm:text-sm">{serverTime}</span>
			</div>

			<!-- Divider -->
			<div class="border-t border-slate-600 my-3 sm:my-4"></div>

			<!-- Client Data Section -->
			<h2 class="font-semibold text-white mb-2 text-sm sm:text-base">{t("ui.dashboard.coordinates", "Player Coordinates")}</h2>
			<div class="bg-slate-700 p-2 sm:p-3 rounded mb-4 text-slate-100 text-xs sm:text-sm font-mono overflow-auto max-h-20">
				{clientData ? JSON.stringify(clientData) : "No data"}
			</div>

			<!-- Action Buttons -->
			<div class="flex flex-row gap-2 mb-4">
				<button
					on:click={handleClientData}
					class="flex-1 bg-green-600 hover:bg-green-700 text-white font-semibold py-2 px-3 sm:px-4 rounded transition-colors duration-200 text-sm sm:text-base"
				>
					{t("ui.dashboard.buttons.getCoords", "Get Coords")}
				</button>
				<button
					on:click={resetCoords}
					class="bg-slate-600 hover:bg-slate-700 text-white font-semibold py-2 px-3 sm:px-4 rounded transition-colors duration-200 text-sm sm:text-base"
				>
					{t("ui.dashboard.buttons.reset", "Reset")}
				</button>
			</div>

			<!-- Close Button -->
			<button
				on:click={closeDialog}
				class="w-full bg-red-600 hover:bg-red-700 text-white font-semibold py-2 px-4 rounded transition-colors duration-200 text-sm sm:text-base"
			>
				{t("ui.dashboard.buttons.close", "Close UI (ESC)")}
			</button>
		</div>
	</div>
</div>
