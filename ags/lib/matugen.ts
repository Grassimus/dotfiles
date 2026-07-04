import { sh, dependencies, getFileSize } from "$lib/utils"
import { wp } from "$lib/services"
import { timeout, idle, Timer } from "ags/time"

import options from "options"

export namespace Matugen {
  let matugenDebounce: Timer | null = null

  type ColorValue = {
    light: string
    dark: string
    default: string
  }

  type Colors = {
    background: ColorValue
    error: ColorValue
    error_container: ColorValue
    inverse_on_surface: ColorValue
    inverse_primary: ColorValue
    inverse_surface: ColorValue
    on_background: ColorValue
    on_error: ColorValue
    on_error_container: ColorValue
    on_primary: ColorValue
    on_primary_container: ColorValue
    on_primary_fixed: ColorValue
    on_primary_fixed_variant: ColorValue
    on_secondary: ColorValue
    on_secondary_container: ColorValue
    on_secondary_fixed: ColorValue
    on_secondary_fixed_variant: ColorValue
    on_surface: ColorValue
    on_surface_variant: ColorValue
    on_tertiary: ColorValue
    on_tertiary_container: ColorValue
    on_tertiary_fixed: ColorValue
    on_tertiary_fixed_variant: ColorValue
    outline: ColorValue
    outline_variant: ColorValue
    primary: ColorValue
    primary_container: ColorValue
    primary_fixed: ColorValue
    primary_fixed_dim: ColorValue
    scrim: ColorValue
    secondary: ColorValue
    secondary_container: ColorValue
    secondary_fixed: ColorValue
    secondary_fixed_dim: ColorValue
    shadow: ColorValue
    surface: ColorValue
    surface_bright: ColorValue
    surface_container: ColorValue
    surface_container_high: ColorValue
    surface_container_highest: ColorValue
    surface_container_low: ColorValue
    surface_container_lowest: ColorValue
    surface_dim: ColorValue
    surface_variant: ColorValue
    tertiary: ColorValue
    tertiary_container: ColorValue
    tertiary_fixed: ColorValue
    tertiary_fixed_dim: ColorValue
  }

  export async function init() {
    wp.connect("notify::wallpaper", () => getColors())
    options.autotheme.subscribe(() => getColors())
  }

  export async function getColors(
    type: "image" | "color" = "image",
    arg = wp.get_wallpaper(),
  ) {
    if (
      !options.autotheme.peek() ||
      !dependencies("matugen") ||
      !getFileSize(arg)
    )
      return

    if (matugenDebounce) matugenDebounce.cancel()

    matugenDebounce = timeout(300, async () => {
      try {
        const colors = await sh(
          `matugen --dry-run -j hex ${type} ${arg} --source-color-index 0`,
        )
        const c = JSON.parse(colors).colors as Colors

        idle(() => {
          const { dark, light } = options.theme

          dark.widget.set(c.on_surface.dark.color)
          light.widget.set(c.on_surface.light.color)
          dark.border.set(c.outline.dark.color)
          light.border.set(c.outline.light.color)
          dark.bg.set(c.surface.dark.color)
          light.bg.set(c.surface.light.color)
          dark.fg.set(c.on_surface.dark.color)
          light.fg.set(c.on_surface.light.color)
          dark.primary.bg.set(c.primary.dark.color)
          light.primary.bg.set(c.primary.light.color)
          dark.primary.fg.set(c.on_primary.dark.color)
          light.primary.fg.set(c.on_primary.light.color)
          dark.error.bg.set(c.error.dark.color)
          light.error.bg.set(c.error.light.color)
          dark.error.fg.set(c.on_error.dark.color)
          light.error.fg.set(c.on_error.light.color)
        })
      } catch (error) {
        console.error("Matugen color generation failed:", error)
      } finally {
        matugenDebounce = null
      }
    })
  }
}
