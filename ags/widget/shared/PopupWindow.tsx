import { onMount } from "ags"
import { Astal, Gdk, Gtk } from "ags/gtk4"
import app from "ags/gtk4/app"
import GObject from "ags/gobject"

import Graphene from "gi://Graphene"

import { Props } from "$lib/utils"

import options from "options"

const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor

export type Position =
	'center' | 'top' | 'top-right' | 'top-center' | 'top-left' |
	'bottom-left' | 'bottom-center' | 'bottom-right'

function onKeyHandler(
	ctrl: Gtk.EventControllerKey,
	keyval: number,
	code: number,
	mod: number,
	w: Gtk.Window,
	onKey?: (ctrl: Gtk.EventControllerKey, keyval: number, code: number, mod: number, w: Gtk.Window) => void
) {
	if (keyval === Gdk.KEY_Escape) w.hide()
	if (keyval === Gdk.KEY_Super_L || keyval === Gdk.KEY_Super_R) hideAllPopups()
	if (onKey) onKey(ctrl, keyval, code, mod, w)
}

function onClickHandler(
	ctrl: Gtk.GestureClick,
	n: number,
	x: number,
	y: number,
	w: Gtk.Window,
	content: Gtk.Widget,
	onClick?: (ctrl: Gtk.GestureClick, n: number, x: number, y: number, w: Gtk.Window, content: Gtk.Widget) => void
) {
	const [, rect] = content.compute_bounds(w)
	const point = new Graphene.Point({ x, y })
	if (!rect.contains_point(point)) w.hide()
	if (onClick) onClick(ctrl, n, x, y, w, content)
}

function getPosConfig(pos: Position) {
	const { START, END, CENTER } = Gtk.Align
	const { SLIDE_UP, SLIDE_DOWN, CROSSFADE } = Gtk.RevealerTransitionType

	switch (pos) {
		case 'top-left': return { halign: START, valign: START, transitionType: SLIDE_DOWN }
		case 'top-center': return { halign: CENTER, valign: START, transitionType: SLIDE_DOWN }
		case 'top-right': return { halign: END, valign: START, transitionType: SLIDE_DOWN }
		case 'center': return { halign: CENTER, valign: CENTER, transitionType: CROSSFADE }
		case 'bottom-left': return { halign: START, valign: END, transitionType: SLIDE_UP }
		case 'bottom-center': return { halign: CENTER, valign: END, transitionType: SLIDE_UP }
		case 'bottom-right': return { halign: END, valign: END, transitionType: SLIDE_UP }
		default: return { halign: CENTER, valign: CENTER, transitionType: CROSSFADE }
	}
}

interface PopupProps extends Astal.Window.ConstructorProps {
	children: JSX.Element | Array<JSX.Element>
	layout?: Position | import("ags").Accessor<Position>
	transitionType?: Gtk.RevealerTransitionType
	/** Part of the mutually-exclusive group: opening it closes other exclusive popups. */
	exclusive?: boolean
}

class Impl extends Astal.Window {
	revealer?: Gtk.Revealer
	// Marks this window as a popup so it can be closed en masse (e.g. super key).
	isPopup = true
	// Popups in the exclusive group hide each other, so at most one is open.
	exclusive = false

	override vfunc_show() {
		if (this.exclusive) {
			for (const w of app.get_windows()) {
				if (w !== this && w instanceof Impl && w.exclusive && w.visible)
					w.hide()
			}
		}
		super.vfunc_show()
		this.revealer?.set_reveal_child(true)
	}

	override vfunc_hide() {
		this.revealer?.set_reveal_child(false)
	}

	performHide() {
		super.vfunc_hide()
		this.notify("visible")
	}
}

const Popup = GObject.registerClass(Impl)

/** Hide every open popup window (used by the super-key bind). */
export function hideAllPopups() {
	for (const w of app.get_windows()) {
		if (w instanceof Impl && w.isPopup && w.visible)
			w.hide()
	}
}

export function PopupWindow({
	name = 'popup',
	class: className,
	layout = 'center',
	transitionType,
	decorated = false,
	visible = false,
	keymode = Astal.Keymode.ON_DEMAND,
	anchor = TOP | BOTTOM | LEFT | RIGHT,
	exclusivity = Astal.Exclusivity.IGNORE,
	layer = Astal.Layer.TOP,
	handleClosing = true,
	exclusive = false,
	onKey,
	onClick,
	children,
	$,
	...props
}: Props<Impl, PopupProps> & {
	handleClosing?: boolean
	onKey?: (ctrl: Gtk.EventControllerKey, keyval: number, code: number, mod: number, w: Gtk.Window) => void
	onClick?: (ctrl: Gtk.GestureClick, n: number, x: number, y: number, w: Gtk.Window, content: Gtk.Widget) => void
}) {
	let content: Gtk.Revealer
	let win: Impl

	const alignment = typeof layout === 'function'
		? (layout as import("ags").Accessor<Position>).as(getPosConfig)
		: getPosConfig(layout ?? 'center')

	const isAccessor = typeof alignment === 'function'

	return (
		<Popup
			$={w => {
				win = w
				w.exclusive = exclusive
				$ && $(w)
			}}
			name={name}
			class={`${name && name + " "}${className}`}
			decorated={decorated}
			visible={visible}
			keymode={keymode}
			anchor={anchor}
			exclusivity={exclusivity}
			layer={layer}
			{...props}
		>
			<Gtk.EventControllerKey onKeyPressed={(ctrl, keyval, code, mod) => handleClosing && onKeyHandler(ctrl, keyval, code, mod, win, onKey)} />
			<Gtk.GestureClick onPressed={(ctrl, n, x, y) => handleClosing && onClickHandler(ctrl, n, x, y, win, content, onClick)} />

			<Gtk.Revealer
				transitionDuration={options.transition.duration}
				transitionType={transitionType ?? (isAccessor ? alignment.as((v: ReturnType<typeof getPosConfig>) => v.transitionType) : alignment.transitionType)}
				halign={isAccessor ? alignment.as((v: ReturnType<typeof getPosConfig>) => v.halign) : alignment.halign}
				valign={isAccessor ? alignment.as((v: ReturnType<typeof getPosConfig>) => v.valign) : alignment.valign}
				onNotifyChildRevealed={(self) => {
					if (!self.get_child_revealed()) {
						win.performHide()
					}
				}}
				$={self => {
					onMount(() => {
						content = self
						win.revealer = self
					})
				}}
			>
				{children}
			</Gtk.Revealer>
		</Popup >
	)
}
