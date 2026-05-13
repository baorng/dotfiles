<script lang="ts">
  let {
    path,
    viewBox = "0 -960 960 960",
  }: {
    path: string;
    viewBox?: string;
  } = $props();
</script>

<svg xmlns="http://www.w3.org/2000/svg" height="20px" {viewBox} width="20px" fill="#e3e3e3">
  <path d={path}></path>
</svg>
