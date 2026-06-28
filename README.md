# Neural Decoding & Spike Sorting

A spike-sorting pipeline and a motor-cortex population-vector decoder, written in MATLAB and built around real extracellular recordings. The work goes from raw voltage to detected and sorted spikes, then uses the spiking activity of a population of motor-cortex neurons to decode intended reach direction.

## What's inside

**1. Spike detection and sorting**
From a raw extracellular recording (rat somatosensory brainstem, whisker air-puff stimulation, sampled at 40 kHz):
- Recover true voltage from the amplified signal and build the time base.
- Threshold the signal and use a one-sample derivative to mark spike onsets.
- Build an inter-spike-interval histogram and a peri-stimulus time histogram (PSTH) aligned to stimulus onset; the peak spiking response sits at roughly 12 ms latency.
- Re-detect spikes at a 3-sigma threshold, extract a waveform around each spike (0.5 ms before to 1 ms after), and overlay roughly 2,900 waveforms with the mean.
- Separate real units from noise in a peak-versus-valley feature space.

**2. Population-vector decoder (brain-machine interface)**
From spike trains recorded simultaneously across 98 primary motor cortex (M1) neurons during a center-out reaching task:
- Compute firing rates in a window around movement onset.
- Fit a cosine tuning curve r(theta) = A * cos(theta - phi) + M to each neuron's directional response.
- Build a population vector, with each neuron weighted by its mean-subtracted firing rate, to decode reach direction.
- Evaluate decoding accuracy on held-out trials using mean angular error.

## Results at a glance
- PSTH peak latency to whisker deflection: about 12 ms
- About 2,900 spike waveforms extracted and overlaid
- Per-neuron cosine tuning fits, then population-vector decoding across 8 reach directions on held-out trials

## Files
| File | Purpose |
| --- | --- |
| `ps6_1a.m` to `ps6_1d.m` | Spike detection: time base, thresholding, derivative onset detection, spike vector |
| `ps6_2a.m` | Inter-spike-interval histogram |
| `ps6_2b.m` | PSTH and latency to peak response |
| `ps6_3b.m` | Spike waveform matrix and superimposed plot |
| `ps6_3c.m` | Peak-versus-valley feature scatter |
| `ps6_4a.m` | Cosine tuning curves for all neurons |
| `ps6_4b.m` | Population vector for a single trial |
| `ps6_4c.m` | Decoding error across held-out trials |
| `my_fit_cos_tune.m` | Helper: cosine tuning fit by linear regression |
| `my_angdiff.m` | Helper: signed angular difference |

## Running it
Requires MATLAB. Put the data files in the project root and run the scripts in order. The data files are not included in this repo (see attribution).

## Data and attribution
- Motor cortex dataset: publicly available center-out reaching data from the Shenoy lab (Stanford), of the kind introduced in Georgopoulos, Schwartz, and Kettner, *Science* (1986). A public mirror is available at github.com/marcin-laskowski/Brain-Machine-Interface.
- Somatosensory recording: provided as course material.

## Context
Developed for BISC 499, Introduction to Computational Neuroscience, at USC.
