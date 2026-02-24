import { mount } from "svelte";
import "./app.css";
import App from "./App.svelte";
import { isEnvBrowser } from "$lib/utils/misc";

if (isEnvBrowser()) {
	const root = document.getElementById("app");
	root!.style.height = "100vh";
}

const app = mount(App, {
	target: document.getElementById("app")!,
});

export default app;
