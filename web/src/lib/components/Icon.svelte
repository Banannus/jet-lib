<script lang="ts">
  import type { SvelteComponent } from "svelte";

  export let name: string;
  export let size: number = 18;
  export let color: string = "currentColor";
  export let strokeWidth: number = 2;

  let Icon: typeof SvelteComponent | null = null;

  const cache: Record<string, typeof SvelteComponent | null> = {};

  function toPascalCase(str: string): string {
    return str
      .split("-")
      .map(s => s.charAt(0).toUpperCase() + s.slice(1))
      .join("");
  }

  async function load(iconName: string): Promise<void> {
    if (!iconName) {
      Icon = null;
      return;
    }

    if (cache[iconName]) {
      Icon = cache[iconName];
      return;
    }

    try {
      const icons = await import("@lucide/svelte");
      const resolved =
        (icons as Record<string, typeof SvelteComponent>)[
          toPascalCase(iconName)
        ] ?? null;

      cache[iconName] = resolved;
      Icon = resolved;
    } catch {
      Icon = null;
    }
  }

  $: load(name);
</script>

{#if Icon}
  <svelte:component
    this={Icon}
    {size}
    {color}
    {strokeWidth}
  />
{/if}
