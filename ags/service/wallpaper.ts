import app from "ags/gtk4/app"
import { createBinding } from "ags"
import GObject, { property, register } from "ags/gobject"
import { execAsync } from "ags/process"

import env from "$lib/env"
import { bash, dependencies, fileExists } from "$lib/utils"

@register()
export default class Wallpaper extends GObject.Object {
	declare static $gtype: GObject.GType<Wallpaper>
	static instance: Wallpaper

	static get_default() {
		return this.instance ??= new Wallpaper()
	}

	@property(String) wallpaper: string
	#available: boolean

	constructor() {
		super()

		this.wallpaper = `${env.paths.home}/.config/background`
		this.#available = dependencies("awww")

		if (!this.#available) return

		this.#apply()

		let prevMonCount = app.get_monitors().length
		createBinding(app, "monitors").subscribe(() => {
			const monCount = app.get_monitors().length
			if (monCount > prevMonCount) {
				prevMonCount = monCount
				this.#apply()
			}
		})
		execAsync("awww-daemon").catch(() => null)
	}

	async #handleHeic(imgPath: string) {
		if (!dependencies("heif-dec")) return
		const tmpImg = `${env.paths.tmp}/heic.png`
		await bash(`heif-dec "${imgPath}" "${tmpImg}" && cp "${tmpImg}" "${this.wallpaper}"`)
	}

	get_wallpaper() {
		return this.wallpaper
	}

	async set_wallpaper(img_path: string) {
		if (!this.#available) return

		const isHeic = img_path.toLowerCase().endsWith(".heic")

		try {
			if (isHeic) {
				await this.#handleHeic(img_path)
			} else {
				await bash(`cp "${img_path}" "${this.wallpaper}"`)
			}
			this.#apply()
		} catch (e) {
			console.error("Failed to set wallpaper:", e)
		}
	}

	readonly #apply = async () => {
		this.notify("wallpaper")

		if (fileExists(this.wallpaper)) {
			await execAsync(`awww clear-cache`)
			await execAsync(`awww img --invert-y --transition-type fade "${this.wallpaper}"`)
		} else {
			await execAsync("awww clear 111111")
		}
	}
}
