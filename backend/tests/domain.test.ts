import {test} from 'node:test';
import {strict as assert} from 'node:assert';
import {canTransition,deliveryRisk} from '../src/domain.js';
test('valid forward delivery transitions',()=>{assert.equal(canTransition('assigned','accepted'),true);assert.equal(canTransition('accepted','completed'),false);assert.equal(canTransition('completed','assigned'),false);});
test('risk scoring deterministic',()=>{const risk=deliveryRisk('2026-01-01T00:00:00Z','in_transit',Date.parse('2026-01-01T00:20:00Z'));assert.equal(risk.level,'high');assert.equal(risk.minutesLate,20);});
