
<script setup>
import { ref, onMounted, onUnmounted, defineEmits } from 'vue';

const props = defineProps({
  options: {
    type: Object,
    default: () => ({ root: null, rootMargin: '100px 0px 100px 0px' }),
  },
});

const emit = defineEmits(['observed']);
const observer = ref(null);
const observedElement = ref(null);

onMounted(() => {
  observer.value = new IntersectionObserver(([entry]) => {
    if (entry && entry.isIntersecting) {
      emit('observed');
    }
  }, props.options);

  if (observedElement.value) {
    observer.value.observe(observedElement.value);
  }
});

onUnmounted(() => {
  if (observer.value) {
    observer.value.disconnect();
  }
});
</script>

<template>
  <div ref="observedElement" class="h-6 w-full" />
</template>
