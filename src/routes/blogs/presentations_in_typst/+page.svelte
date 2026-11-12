<h1 id="presentations-in-typst">Presentations in Typst</h1>
<p>I recently made a presentation that I called “Clicks to Pix”. It was
a detailed guide on how information travels from a single keystroke over
USB to a computer. Then how the modern desktop stack is organized and
deals with the input. And finally, how the new outputs are generated and
rendered within the linux kernel over HDMI.</p>
<p>Regardless, I had previously made a presentation for the same club,
and used <a href="https://tools.suckless.org/sent/">sent</a> for slides.
It was a bit of a sad experience to put it lightly. It’s very walled in
and inflexible which is why I yearned for more.</p>
<h2 id="enter-typst">Enter Typst</h2>
<p>I had my eye on <a href="https://typst.app/home/">Typst</a> for a
while up until a while ago. Many many many theoretical computer science
and math classes later and I figured it was time to stop doing
everything by hand. In all honesty, I prefer to do my work by hand, but
it got to a point where I needed to make so many edits to my work, that
I was either running out of erasers or hand strength. Typst it was. The
decision wasn’t even hard. Briefly, while in class, I had the
displeasure of seeing my professor’s latex editor. I was mortified. The
<em>foul</em> overuse of backslashes devastated me. The typst tooling
was easy to get and use without much setup.</p>
<p>Obviously typst is great at typesetting documents. In the past couple
weeks, I rewrote my resume, and decided typst would be my medium. The
experience was great, leading me to ponder the prospect of presentations
in typst. I was pleasantly surprised.</p>
<h2 id="presentation-format">Presentation Format</h2>
<p>To begin the presentation all you need is one line:
<code>#set page("presentation-16-9")</code>. If you don’t use 16:9 you
can specify a custom size. For example, I used
<code>#set page(width: 340mm, height: 220mm)</code>. This just tells
typst how big each slide should be, as you can probably guess. This you
can use all the normal typst patterns to create the slides. The only
other gotcha is that you denote pagebreaks with
<code>#pagebreak()</code>. This ends up giving nice dividers in the
source between the content of each slide. I really found joy in the
creation of the presentation, which I can’t say is true for other
presentation software.</p>
<h2 id="small-example">Small Example</h2>
<p>Below is a small exmaple along with the produced PDF. The
<code>#set</code> and <code>#show</code> rules are for text sizing, and
some other small style choices.</p>
<div class="sourceCode" id="cb1"><pre
class="sourceCode typst"><code class="sourceCode typst"><span id="cb1-1"><span class="kw">#set</span> <span class="va">page</span><span class="op">(</span>width<span class="op">:</span> <span class="fl">340mm</span><span class="op">,</span> height<span class="op">:</span> <span class="fl">220mm</span><span class="op">)</span></span>
<span id="cb1-2"></span>
<span id="cb1-3"><span class="kw">#set</span> <span class="va">text</span><span class="op">(</span>size<span class="op">:</span> <span class="fl">2.5em</span><span class="op">)</span></span>
<span id="cb1-4"><span class="kw">#show</span> heading<span class="op">.</span>where<span class="op">(</span>level<span class="op">:</span> <span class="dv">1</span><span class="op">):</span> <span class="kw">set</span> <span class="va">text</span><span class="op">(</span>size<span class="op">:</span> <span class="fl">2em</span><span class="op">)</span></span>
<span id="cb1-5"><span class="kw">#show</span> heading<span class="op">.</span>where<span class="op">(</span>level<span class="op">:</span> <span class="dv">2</span><span class="op">):</span> <span class="kw">set</span> <span class="va">text</span><span class="op">(</span>size<span class="op">:</span> <span class="fl">1.25em</span><span class="op">)</span></span>
<span id="cb1-6"></span>
<span id="cb1-7"><span class="kw">#</span>align<span class="op">(</span>horizon<span class="op">)[</span></span>
<span id="cb1-8"><span class="fu">  = `Clicks` $arrow$ #text(red)[P]#text(green)[i]#text(blue)[x] \</span></span>
<span id="cb1-9">  By: Harrison DiAmbrosio</span>
<span id="cb1-10"><span class="op">]</span></span>
<span id="cb1-11"></span>
<span id="cb1-12"><span class="kw">#</span>pagebreak<span class="op">()</span></span>
<span id="cb1-13"></span>
<span id="cb1-14"><span class="fu">== &gt; Where do we start?</span></span>
<span id="cb1-15"></span>
<span id="cb1-16">*There are three parts we need to keep track of*</span>
<span id="cb1-17">+ The peripherals (keyboard, mouse, laptop lids, etc.)</span>
<span id="cb1-18">+ The desktop stack</span>
<span id="cb1-19">+ Display / Output</span>
<span id="cb1-20"></span>
<span id="cb1-21"><span class="kw">#</span>pagebreak<span class="op">()</span></span>
<span id="cb1-22"></span>
<span id="cb1-23"><span class="fu">= Chapter 1</span></span>
<span id="cb1-24"><span class="fu">== _Clickity click clack_</span></span>
<span id="cb1-25"></span>
<span id="cb1-26"><span class="kw">#</span>pagebreak<span class="op">()</span></span>
<span id="cb1-27"></span>
<span id="cb1-28"><span class="fu">== Clarifying Assumptions</span></span>
<span id="cb1-29"></span>
<span id="cb1-30">We assume the following:</span>
<span id="cb1-31">+ Input devices communicate over *USB*</span>
<span id="cb1-32">+ Output&#39;s communicate over *HDMI*</span>
<span id="cb1-33">+ Using the *Linux* kernel</span>
<span id="cb1-34">+ Using the *Wayland* protocol</span>
<span id="cb1-35"></span>
<span id="cb1-36">These assumptions are made for simplicity</span>
<span id="cb1-37"></span>
<span id="cb1-38">Fundamentally identical process in other environments</span></code></pre></div>
<p><img src="/images/clicks_to_pix1.png"
alt="First presentation slide" /> <img src="/images/clicks_to_pix2.png"
alt="Second presentation slide" /> <img src="/images/clicks_to_pix3.png"
alt="Third presentation slide" /> <img src="/images/clicks_to_pix4.png"
alt="Fourth presentation slide" /></p>
